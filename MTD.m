% Generate Random Glucose Data and Visualize with Meal Effects

% Parameters for simulation
num_intervals = 48; % Number of half-hour intervals in a day
threshold_hypo = 70; % Hypoglycemia threshold
threshold_hyper = 180; % Hyperglycemia threshold
bolus_effect = -50; % Impact of bolus insulin

% Generate random glucose levels with realistic fluctuations
time = linspace(0, 24, num_intervals); % Time in hours
glucose_levels = 80 + 40*randn(1, num_intervals); % Mean 80, std dev 40

% Smooth the data to make it more realistic
glucose_levels = smoothdata(glucose_levels, 'gaussian', 5);

% Adjust glucose levels based on assumed meal and sleep times
for i = 1:num_intervals
    current_time = time(i);
    if current_time >= 23 || current_time < 7 % Sleep time
        glucose_levels(i) = glucose_levels(i) - 10; % Lower glucose slightly during sleep
    elseif current_time >= 8 && current_time < 8.5 % Breakfast spike
        glucose_levels(i) = glucose_levels(i) + 50;
    elseif current_time >= 10 && current_time < 10.5 % Morning snack
        glucose_levels(i) = glucose_levels(i) + 30;
    elseif current_time >= 12 && current_time < 12.5 % Lunch spike
        glucose_levels(i) = glucose_levels(i) + 50;
    elseif current_time >= 17 && current_time < 17.5 % Afternoon snack
        glucose_levels(i) = glucose_levels(i) + 30;
    elseif current_time >= 20 && current_time < 20.5 % Dinner spike
        glucose_levels(i) = glucose_levels(i) + 50;
    end
    % Apply bolus insulin if glucose exceeds hyperglycemia threshold
    if glucose_levels(i) > threshold_hyper
        glucose_levels(i) = glucose_levels(i) + bolus_effect;
    end
end

% Clip glucose levels to a realistic range
glucose_levels = max(50, min(250, glucose_levels));

% Visualize the glucose data
figure;
plot(time, glucose_levels, '-o', 'LineWidth', 1.5);
hold on;

% Highlight thresholds
line([0, 24], [threshold_hypo, threshold_hypo], 'Color', 'blue', 'LineStyle', '--', 'LineWidth', 1.5);
line([0, 24], [threshold_hyper, threshold_hyper], 'Color', 'red', 'LineStyle', '--', 'LineWidth', 1.5);

% Add labels and legend
title('Simulated Glucose Levels Over a Day with Meal, Sleep, and Bolus Insulin Effects');
xlabel('Time (hours)');
ylabel('Glucose Level (mg/dL)');
legend({'Glucose Levels', 'Hypoglycemia Threshold', 'Hyperglycemia Threshold'}, 'Location', 'best');
grid on;

% Adjust axes
xlim([0 24]);
ylim([50 250]);
