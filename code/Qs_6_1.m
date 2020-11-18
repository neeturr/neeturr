clc;clear all;
n1=5;output=zeros(4,n1);n2=7;% no.of terminal states
epi=100;alpha=0.1;gamma=1; % initialzing values
mct=0.5*ones(1,n2);tdt=0.5*ones(1,n2);mct(1)=0;mct(end)=0;tdt(1)=0;tdt(end)=0;
for i=1:epi
s=4;state=[s];k=rand(1); Rew=0; % starting from state C
while(1<s && s<7)  % checking for the state index   
    if(k<0.5)      % initilial value for each state 
        s1=s+1;
    else
        s1=s-1;
    end
    if(s1~=7)  % checking for terminal state
        reward=0;else
        reward=1;
    end
    Rew=Rew+reward;  % finding the rewards
    
    tdt(s)=tdt(s)+alpha*(reward+gamma*tdt(s1)-tdt(s)); % update value function for TD learning
    state=[state;s1];
    s=s1;
end  
    for j=1:length(state)  
        mct(state(j))=mct(state(j))+alpha*(Rew-mct(state(j))); % MC value function calculating all the states
     end
end

mct=mct(2:end-1);
tdt=tdt(2:end-1);

output(1,:)=tdt; 
truevalue = (1:5)/6;  % truth
plot(1:5,truevalue,'black');
hold on; 
plot(1:5,output(1,:),'b')