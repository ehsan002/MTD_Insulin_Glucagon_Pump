% Generate Random Glucose Data and Compare Basal and Bolus Insulin Impact

% Parameters for simulation
num_intervals = 48; % Number of half-hour intervals in a day
threshold_hypo = 70; % Hypoglycemia threshold
threshold_hyper = 180; % Hyperglycemia threshold
basal_effect = -10; % Impact of basal insulin per interval
bolus_effect = -40; % Impact of bolus insulin on a glucose spike

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
end

% Clip glucose levels to a realistic range
glucose_levels = max(50, min(250, glucose_levels));

% Duplicate glucose levels to apply basal and bolus insulin effects
glucose_levels_basal_bolus = glucose_levels;
bolus_applied = zeros(size(time)); % Track bolus insulin application

% Apply basal insulin effect
for i = 1:num_intervals
    glucose_levels_basal_bolus(i) = glucose_levels_basal_bolus(i) + basal_effect;
    % Apply bolus insulin effect when glucose exceeds hyperglycemia threshold
    if glucose_levels_basal_bolus(i) > threshold_hyper
        glucose_levels_basal_bolus(i) = glucose_levels_basal_bolus(i) + bolus_effect;
        bolus_applied(i) = glucose_levels_basal_bolus(i); % Record bolus insulin impact
    end
end

% Clip glucose levels with basal and bolus insulin to a realistic range
glucose_levels_basal_bolus = max(50, min(250, glucose_levels_basal_bolus));

% Visualize the glucose data
figure;
plot(time, glucose_levels, '-o', 'LineWidth', 1.5);
hold on;
plot(time, glucose_levels_basal_bolus, '-x', 'LineWidth', 1.5);
scatter(time(bolus_applied > 0), bolus_applied(bolus_applied > 0), 80, 'red', 'filled', 'DisplayName', 'Bolus Insulin');

% Highlight thresholds
line([0, 24], [threshold_hypo, threshold_hypo], 'Color', 'blue', 'LineStyle', '--', 'LineWidth', 1.5);
line([0, 24], [threshold_hyper, threshold_hyper], 'Color', 'red', 'LineStyle', '--', 'LineWidth', 1.5);

% Add labels and legend
title('Comparison of Glucose Levels With Basal and Bolus Insulin Impact');
xlabel('Time (hours)');
ylabel('Glucose Level (mg/dL)');
legend({'Without Insulin', 'With Basal and Bolus Insulin', 'Bolus Insulin Impact', 'Hypoglycemia Threshold', 'Hyperglycemia Threshold'}, 'Location', 'best');
grid on;

% Adjust axes
xlim([0 24]);
ylim([50 250]);
