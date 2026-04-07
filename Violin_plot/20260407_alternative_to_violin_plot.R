# Let's say I've got categories on the x-axis and a continuous variable for the y-axis. Sometimes, instead of a violin plot,
#   I want to see where all of the individual points are along the y-axis ). Plotting many points with the same x-coordinate
#   risks putting them on top of one another. Jittering the points randomly in the x-dimension reduces this problem, but it
#   doesn't guarantee that you won't get overlap, and it tends to make the plot look messy.
#
# The function place_points_no_overlap takes your data and the variable(s) you want to use to categorize them along the x-axis.
#   It enforces a minimum two-dimensional distance (d) between points, by moving each point outward in the x-dimension by a step
#   size e if they overlap another point, but it doesn't move points unless it's necessary. There's a time cutoff (t, in seconds)
#   so that the function doesn't grind away at this task forever.
#
# Full disclosure: the function was written almost entirely by ChatGPT.
#
# The code below the function creates a simplified version of a plot that I made to look at correlations between metabolomic data
#   sets, split up by metabolite super-pathway. If you're interested in using this function, I recommend running it on your data
#   and looking at the output table (here, it's called points_positions), to see how the output table is structured.



library(data.table)
library(ggplot2)

place_points_no_overlap <- function(
    dt,
    y_col = NULL,
    group_cols = NULL,
    d = 0.02,
    e = d / 5,
    t = 10 * 60,
    seed = 1
) {
  stopifnot(is.data.table(dt))
  stopifnot(y_col %in% names(dt))
  stopifnot(all(group_cols %in% names(dt)))

  dt2 <- copy(dt)
  dt2 <- dt2[!is.na(get(y_col))]
  dt2[, y_val := pmax(get(y_col), 0)]

  set.seed(seed)
  start_time <- Sys.time()

  group_index_dt <- unique(dt2[, ..group_cols])
  group_index_dt[, group_id___ := .I]

  dt2 <- merge(dt2, group_index_dt, by = group_cols, all.x = TRUE, sort = FALSE)

  out_list <- vector("list", nrow(group_index_dt))

  for (gid in group_index_dt$group_id___) {
    g <- dt2[group_id___ == gid]
    g <- g[sample(.N)]

    placed_x <- numeric(0)
    placed_y <- numeric(0)
    x_out <- rep(NA_real_, g[, .N])

    for (i in seq_len(g[, .N])) {
      elapsed <- as.numeric(difftime(Sys.time(), start_time, units = "secs"))
      if (elapsed > t) {
        warning("Time limit exceeded before all points were placed.")
        g[, x_offset := x_out]
        out_list[[gid]] <- g
        out_list <- out_list[seq_len(gid)]
        return(rbindlist(out_list, use.names = TRUE, fill = TRUE))
      }

      y_new <- g$y_val[i]

      if (length(placed_x) == 0L) {
        x_new <- 0
      } else {
        k <- 0L
        placed <- FALSE

        repeat {
          candidates <- if (k == 0L) 0 else c(-k * e, k * e)

          for (x_try in candidates) {
            dist2 <- (x_try - placed_x)^2 + (y_new - placed_y)^2
            if (all(sqrt(dist2) >= d)) {
              x_new <- x_try
              placed <- TRUE
              break
            }
          }

          if (placed) break
          k <- k + 1L

          elapsed <- as.numeric(difftime(Sys.time(), start_time, units = "secs"))
          if (elapsed > t) {
            warning("Time limit exceeded before all points were placed.")
            g[, x_offset := x_out]
            out_list[[gid]] <- g
            out_list <- out_list[seq_len(gid)]
            return(rbindlist(out_list, use.names = TRUE, fill = TRUE))
          }
        }
      }

      x_out[i] <- x_new
      placed_x <- c(placed_x, x_new)
      placed_y <- c(placed_y, y_new)
    }

    g[, x_offset := x_out]
    out_list[[gid]] <- g
  }

  rbindlist(out_list, use.names = TRUE, fill = TRUE)
}

pdt <- fread("20260407_data_for_alternative_to_violin_plot.txt")
points_positions <- place_points_no_overlap(pdt, y_col = "pearson_r", group_cols = "B3_SUPER_PATHWAY", d = 0.055)

ggplot(data = points_positions) +
  geom_point(aes(x = group_id___+x_offset, y = y_val, fill = B3_SUPER_PATHWAY),
             shape = 21,
             size = 2.4,
             stroke = 0.2) +
  labs(
    x = NULL,
    y = expression("Pearson's " * italic(r)),
    fill = "Metabolon\nsuper-pathway"
  ) +
  theme(
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank()
  ) + guides(
    fill = guide_legend(
      override.aes = list(size = 4)   # increase legend point size
    ))
