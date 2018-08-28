setwd("C:/Users/Tom/Dropbox/Leptop backup/TAU 2015/Schonberg_Lab/paper_2016/DDM")

for (sub in 1:10) {
    system("construct-samples.exe -a 1 -z 0.5 -v -3 -t 0.5 -d 0 -Z 0 -V 0 -T 0 -r -N 1 -n 40 -p 5 -o temp1.lst")
    system("construct-samples.exe -a 1 -z 0.5 -v -1 -t 0.5 -d 0 -Z 0 -V 0 -T 0 -r -N 1 -n 40 -p 5 -o temp2.lst")
    system("construct-samples.exe -a 1 -z 0.5 -v  1 -t 0.5 -d 0 -Z 0 -V 0 -T 0 -r -N 1 -n 40 -p 5 -o temp3.lst")
    system("construct-samples.exe -a 1 -z 0.5 -v  3 -t 0.5 -d 0 -Z 0 -V 0 -T 0 -r -N 1 -n 40 -p 5 -o temp4.lst")

    S1 = read.table("temp1.lst", header = FALSE)
    S2 = read.table("temp2.lst", header = FALSE)
    S3 = read.table("temp3.lst", header = FALSE)
    S4 = read.table("temp4.lst", header = FALSE)

    S = rbind(S1,S2,S3,S4)
    C = c(rep(1,40), rep(2,40), rep(3,40), rep(4,40))
    S = cbind(C, S)

    fn = sprintf("%d.dat", sub)
    write.table(S, fn, col.names=FALSE, row.names=FALSE)
}

unlink("temp1.lst")
unlink("temp2.lst")
unlink("temp3.lst")
unlink("temp4.lst")

