function [ PX1,PY1,PX2,PY2 ] = find_black( F )

para_y=17;
para_x=10;

[y,x]=size(F);
F=im2bw(F);
for i=1:y
    for j=1:x
        if (F(i,j)==0)
            F(i,j)=1;
        else
            F(i,j)=0;
        end
    end
end

black_y=zeros(y,1);  
for i=1:y  
   for j=1:x  
             if(F(i,j)==1)   
                black_y(i,1)= black_y(i,1)+1;   
            end    
     end         
 end  
 [temp MaxY]=max(black_y);  
 PY1=MaxY;  
 while ((black_y(PY1,1)>=para_y)&&(PY1>1))  
        PY1=PY1-1;  
 end      
 PY2=MaxY;  
 while ((black_y(PY2,1)>=para_y)&&(PY2<y))  
        PY2=PY2+1;  
 end  
 %IY=I(PY1:PY2,:,:);  
 black_x=zeros(1,x);  
 for j=1:x  
     for i=PY1:PY2  
            if(F(i,j)==1)  
                black_x(1,j)= black_x(1,j)+1;                 
            end    
     end         
 end  
    
 PX1=1;  
 while ((black_x(1,PX1)<para_x)&&(PX1<x))  
       PX1=PX1+1;  
 end      
 PX2=x;  
 while ((black_x(1,PX2)<para_x)&&(PX2>PX1))  
        PX2=PX2-1;  
 end  
 PX1=PX1-1;  
 PX2=PX2+1;  


end

