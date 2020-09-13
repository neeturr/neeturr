clc; clear all; close all;
chance= 2000; arms=10; steps= 1000;sigma=.36; initial=0;% Initializing the variables
phistar= randn(chance,arms); % Generating gaussian random variables for best arm
phia=randn(chance,arms);     % Generating gaussian random variables other arms
earray=0.1;  % Value of epsilon
c=4; t=0;alpha=.1;  % giving values for c,t and alpha
Avgrwd= zeros(length(earray),steps);  % Initilizing the expected reward variable
Optrwd= zeros(length(earray),steps);  % Initializing the optimal reward
for i=1:length(earray) 
    eps=earray(i);
    reward=zeros(1,1);
    phia1=zeros(size(phia));  % variable to store the estimate of each arm
    phin=ones(chance,arms);   % variable for no.of times the arm is drawn
    phis=phia1;               
    
    reward1=zeros(chance,steps);
    action1=zeros(chance,steps);
    for j=1:chance
        for k=1:steps
            if(rand(1)<=eps)
              a=randi([1,10],1); % Uniformly chose any of the arm from 1 to 10 (explore)
            else
               [x,a]= max(phia1(j,:));  % Arm with maximum estimate stored in a (exploit)
            end
            
      [x1,a1]=max(phistar(j,:));    % best arm a1
      if(a==a1)
          action1(j,k)=1;           % best arm chosen or not
      end
      reward1=phistar(j,a)+sigma*randn(1); % reward for chosing that arm
      totrew(j,k)=reward1;     
      phin(j,a)=phin(j,a)+1;               % next draw
      phis(j,a)=phis(j,a)+reward1;         % sum of the rewards till that step
      phia1(j,a)=phis(j,a)/phin(j,a); 
%       phia1(j,a)=phis(j,a)/phin(j,a);      % estimate till that step
        end
    end
    avgrew=mean(totrew,1);                 % Average of the total rewards at a particular time
     
end
%% Upper confidence bound with c=2
      phia2=zeros(size(phia));  % variable to store the estimate of each arm
      phin1=1;                  % variable for no.of times the arm is drawn
      phis1=phia2;
     reward2=zeros(chance,steps);
    action2=zeros(chance,steps);
    for j=1:chance
        for k=1:steps
            if (rand(1)<=eps)
             [x2,a2]=max(phia2(j,:)+(c.*(sqrt((log(k)/(phin1))))));%Applying euqtion of UCB for selecting non optimal arms
            else
               [x2,a2]= max(phia2(j,:));  % Arm with maximum estimate stored in a (exploit)
            end
        [x1,a1]=max(phistar(j,:));    % best optimal arm a1
           if(a2==a1)                 % comparing the true arm with the estimated arm
          action2(j,k)=1;             % Updating the action variable
          phin1=phin1+1;              % Updating the no.of optimal arms picked
          alpha=rand(1);              % Changing alpha each time
            % best arm chosen or not
           end
         reward2=phistar(j,a2)+sigma*randn(1); % reward for chosing that arm
         totrew1(j,k)=reward2; 
        
         phis1(j,a2)=phia2(j,a2)+(((alpha.*(reward2-phia2(j,a2))))); % Finding the next total estimate
         phia2(j,a2)=phis1(j,a2)./phin1;          % Average estimate till that step
         end
    end
    avgrew1(:,:)=mean(totrew1,1);           
    hold on
    plot(1:steps,avgrew(:,:));             % Plotting
    hold on
    plot(1:steps,avgrew1(:,:));             % Plotting
    hold on

xlabel('steps');
ylabel('average reward');
legend('eps=0','eps=0.01','eps=0.1');
hold on

xlabel('steps');
ylabel('% Optimal Action');
legend('eps=0','eps=0.01','eps=0.1');
