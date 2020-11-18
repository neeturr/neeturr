clc;clear all;close all;

N=500000;C=52;  % Initializing episodes and cards
s=260;          % No.of states using 12,13 and 2
rewcnt=zeros(s,2);  % Initalizing the variables
rewsum=zeros(s,2);
optpol=ones(1,s);
actpol=zeros(s,2);
for i=1:N
  d=randperm(C);state=[];  % randomly choosing cards
  pl=d(1:2);d=d(3:end);    % selecting first 2 cards for the player
  dl=d(1:2);d=d(3:end);    % selecting next two cards for the dealer
  valued=mod(dl-1,13)+1;vald=min(valued,10);smd=sum(vald);cd=d(1); % Calculating the value of cards
  valuep=mod(pl-1,13)+1;valp=min(valuep,10);smp=sum(valp);         % Calculating values for player                                       card=d(1);
  if(any(valued==1)) && (smd<=11)   % checking for usable ace for dealer
     smd=smd+10;
     aced=1;else
     aced=0;
  end
  if(any(valuep==1)) && (smp<=11)  % checking for usable ace for player
     smp=smp+10;
     acep=1;else
     acep=0;
  end
      while(smp<12) % hitting until the initial sum is greater that 12
      pl=[pl,d(1)];d=d(2:end);
    valuep=mod(pl-1,13)+1;valp=min(valuep,10);smp=sum(valp);
    if(any(valuep==1)) && (smp<=11)
        smp=smp+10;
        acep=1;else
        acep=0;
    end
         end
    valuep=mod(pl-1,13)+1;valp=min(valuep,10);smp=sum(valp);
    if(any(valuep==1)) && (smp<=11) % checking for usable ace for player
        smp=smp+10;
        acep=1;else
        acep=0;
    end
      cd1=mod(cd-1,13)+1;
    state(1,:)=[smp,cd1,acep]; % storing in the first state 
m=1;
n=sub2ind([10,13,2],state(m,1)-12+1,state(m,2),state(m,3)+1); % state using the policy pi
optpol(n)=unidrnd(2)-1;n1=optpol(n);  % initial random policy for exploring 
while(n1 && (smp<22)) % hitting until policy pi and value of the card of player until 22
    pl=[pl,d(1)];d=d(2:end);
    valuep=mod(pl-1,13)+1;valp=min(valuep,10);smp=sum(valp);
    if(any(valuep==1)) && (smp<=11)
        smp=smp+10; 
        acep=1;else
        acep=0;
    end
    cd1=mod(cd-1,13)+1;
        valuep=mod(pl-1,13)+1;valp=min(valuep,10);smp=sum(valp);
    if(any(valuep==1)) && (smp<=11)
        smp=smp+10; 
        acep=1;else
        acep=0;
    end
    state(end+1,:)=[smp,cd1,acep];  % storing in the last state
    
if(smp<=21) % checking going bust
 m=m+1;   
n=sub2ind([21-12+1,13,2],state(m,1)-12+1,state(m,2),state(m,3)+1);
n1=optpol(n); % change of policy
end
end
while(smd<17)  % hit until value upto 17 for dealer 
    dl=[dl,d(1)];d=d(2:end);
    valued=mod(dl-1,13)+1;vald=min(valued,10);smd=sum(vald);
    if(any(valued==1)) && (smd<=11) % checking for usable ace
        smd=smd+10;
        aced=1;else
        aced=0;
    end
end
%%%%%%%%%%%%%%% Determing rewards%%%%%%%%%%%
if(smp>21)
    reward=-1;end 
if(smd>21)
    reward=1; end 
if(smp==smd)
    reward=0; end 
if(smp>smd)
    reward=1;
else reward=-1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=1:size(state,1)
    if((state(j,1)<=21)&&(state(j,1)>=12)) % computing the action value functions
        n2=sub2ind([21-12+1,13,2],state(j,1)-12+1,state(j,2),state(j,3)+1);
        n3=optpol(n2)+1;
        rewcnt(n2,n3)=rewcnt(n2,n3)+1; % reward count
        rewsum(n2,n3)=rewsum(n2,n3)+reward; % reward sum
        actpol(n2,n3)=rewsum(n2,n3)/rewcnt(n2,n3); % state action policy
        [x,g]=max(actpol(n2,:));optpol(n2)=g-1; % computing the optimal policy
    end
end
end
valuefun=max(actpol,[],2); % action value function 
valuefun = reshape( valuefun, [21-12+1,13,2]); % changing axis bound

figure; mesh( 1:13, 12:21, valuefun(:,:,1) );
figure; mesh( 1:13, 12:21,  valuefun(:,:,2) );
 
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
