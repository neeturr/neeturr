clc; clear all; close all;
chance= 2000; arms=10; steps= 1000;sigma=.01; initial=0;% Initializing the variables
phistar= randn(chance,arms)+4; % Generating gaussian random variables for best arm with mean 4
phia=randn(chance,arms)+4;  % Generating gaussian random variables other arms with mean 4
alpha_vector=[0.4,0.1];     % Alpha vector
Optrwd= zeros(length(alpha_vector),steps);  % Initializing the optimal reward
for i=1:length(alpha_vector)
    alpha=alpha_vector(i);
    phia1=zeros(size(phia));  % Initializing variable to store the estimate of each arm
    phin=1;                   % Initializing variable for no.of times the arm is drawn
    phis=phia1; 
    rew_avg=0;t=0;
    for j=1:chance
        for k=1:steps
            est=exp(phia1(j,:));   
            prob(j,:)=est/sum(est);% Probability of picking the optimal arm
            I=eye(j,arms);

                [x,a]=max(prob(j,:));  % Obtained the arm with maximum probability
            
            [x1,a1]=max(phistar(j,:)); % best arm
             if(a==a1)                 % comparing with best arm
              action1(j,k)=1;           
              phin=phin+1;             % updating the no.of times optimal arm chosen
             
            reward1=phistar(j,a)+sigma*randn(1);   % Generating rewards for optimal arm
            rew_avg=(reward1-rew_avg)/phin;        % Average reward generated 
            baseline=0;    
            phia1(j,a)= phia1(j,a)+(alpha*(reward1-baseline).*(I(j,a)-prob(j,a))); % Gradient bandit algorithm
             else
                 t=t+1;
            reward1=phistar(j,a)+sigma*randn(1); % reward for sub-optimal arm
            rew_avg=(reward1-rew_avg)/t;    
            baseline=0;  
            phia1(j,a)=phia1(j,a)-(alpha*(reward1-baseline).*prob(j,a)); % gradient alogorithm for sub-optimal arm
             end
        end
    end
        percentaction=mean(action1,1);         % percentage of the optimal action picked for each step
        Optrwd(i,:)=percentaction(:)*100;
            
        plot(1:steps,Optrwd(i,:));   % plotting for different values of alpha
        hold on
end
            