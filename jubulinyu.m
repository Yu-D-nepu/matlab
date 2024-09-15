function dataline=jubulinyu(O_data,Outputline,num)
[row,line]=size(O_data);
[Row,Line]=size(Outputline);

dataline=[];
dataline(1,:)=Outputline(2,1:num+1);
ccount(1)=1;
for i=2:line-1
   for j=1:Line-num
       if Outputline(1,j)== O_data(1,i)
           dataline(i,:)=Outputline(2,j-num/2:j+num/2);
           ccount(i)=j;
       end
   end
end
dataline(line,:)=Outputline(2,Line-num:Line);
plot(dataline(line,:))
end
