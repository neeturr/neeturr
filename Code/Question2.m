clc; clear all; close all;
chance= 2000; arms=10; steps= 1000; sigma=4; % Initializing the variables
phistar= mvnrnd(zeros(chance,arms),eye(arms)); % Generating gaussian random variables for best arm
phia=mvnrnd(phistar,eye(arms));  % Generating gaussian random variables other arms
earray=[0,0.01,0.1];  % Array of epsilon
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
      phia1(j,a)=phis(j,a)/phin(j,a);      % estimate till that step
        end
    end
    avgrew=mean(totrew,1);                 % Average of the total rewards at a particular time
    Avgrwd(i,:)=avgrew(:);
    percentaction=mean(action1,1);         % percentage of the optimal action picked for each step
    Optrwd(i,:)=percentaction(:)*100;
    
    subplot(2,1,1)
    plot(1:steps,Avgrwd(i,:));             % Plotting
    hold on
    subplot(2,1,2);
    plot(1:steps,Optrwd(i,:));
    hold on
end 
hold on
xlabel('steps');
ylabel('average reward');
legend('eps=0','eps=0.01','eps=0.1');
hold on

xlabel('steps');
ylabel('% Optimal Action');
legend('eps=0','eps=0.01','eps=0.1');
