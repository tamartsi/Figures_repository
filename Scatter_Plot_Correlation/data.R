#Generate Mock Data: rsids and p-values from two analyses of same data using different methods

df_pval <- data.frame(pval_method1=round(runif(10000,0.00000001,0.99999999),8),
                      noise=rnorm(10000,0,0.1))
df_pval$pval_method2 <- df_pval$pval_method1+df_pval$noise
df_pval$pval_method2 <- ifelse(df_pval$pval_method2>1,0.99999999,df_pval$pval_method2)
df_pval$pval_method2 <- ifelse(df_pval$pval_method2<0,0.00000001,df_pval$pval_method2)
df_pval$rsid <- paste0("rs", 1:10000)

method1 = subset(df_pval, select = c(rsid, pval_method1))
method2 = subset(df_pval, select = c(rsid, pval_method2))

write.table(method1, file = "method1_data.txt", sep = "\t", row.names = FALSE, col.names = TRUE)
write.table(method2, file = "method2_data.txt", sep = "\t", row.names = FALSE, col.names = TRUE)
