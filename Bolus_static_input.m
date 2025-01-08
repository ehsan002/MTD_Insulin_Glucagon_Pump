% Generate Static Glucose Data and Compare Basal and Bolus Insulin Impact

% Parameters for simulation
num_intervals = 48; % Number of half-hour intervals in a day
threshold_hypo = 70; % Hypoglycemia threshold
threshold_hyper = 180; % Hyperglycemia threshold
basal_effect = -10; % Impact of basal insulin per interval
bolus_effect = -40; % Impact of bolus insulin on a glucose spike

% Define static glucose data for a typical day
time = linspace(0, 24, num_intervals); % Time in hours
glucose_levels = [
    80, 75, 70, 68, 66, 65, 64, 63, 85, 130, ... % Night to morning
    170, 190, 180, 175, 140, 135, 120, 110, 160, 200, ... % Breakfast and snacks
    220, 210, 190, 185, 140, 130, 120, 115, 140, 180, ... % Lunch
    220, 210, 200, 195, 160, 150, 140, 130, 120, 115, ... % Afternoon snacks and evening
    170, 190, 200, 195, 180, 170, 160, 150]; % Dinner and late evening

% Smooth the static data to make it more realistic
glucose_levels = smoothdata(glucose_levels, 'gaussian', 5);

% Uncomment the lines below to generate random glucose levels instead of static data
% glucose_levels = 80 + 40*randn(1, num_intervals); % Mean 80, std dev 40
% glucose_levels = smoothdata(glucose_levels, 'gaussian', 5);

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
