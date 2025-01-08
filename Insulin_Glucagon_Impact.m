% Combined Impacts of Glucagon, Basal, and Bolus Insulin - Simulation

% Parameters for simulation
num_intervals = 48; % Number of half-hour intervals in a day
threshold_hypo = 70; % Hypoglycemia threshold
threshold_hyper = 180; % Hyperglycemia threshold
basal_effect = -10; % Impact of basal insulin per interval
glucagon_effect = 50; % Impact of glucagon on hypoglycemia
bolus_effect = -60; % Impact of bolus insulin on hyperglycemia
bolus_threshold = 200; % Bolus insulin trigger threshold

% Define custom glucose data for a specific scenario
time = linspace(0, 24, num_intervals); % Time in hours
glucose_levels = [
    65, 63, 60, 58, 57, 56, 55, 54, 50, 48, ... % Prolonged hypoglycemia
    85, 120, 115, 110, 108, 107, 106, 105, 140, 160, ... % Breakfast and snacks
    175, 185, 200, 220, 230, 240, 250, 240, 230, 220, ... % Lunch spike
    200, 180, 160, 140, 130, 120, 110, 100, 90, 85, ... % Afternoon snacks
    80, 75, 70, 65, 60, 55, 50, 45]; % Evening and late night

% Smooth the custom data
glucose_levels = smoothdata(glucose_levels, 'gaussian', 5);

% Duplicate glucose levels for simulation
glucose_levels_combined = glucose_levels;
glucagon_applied = zeros(size(time)); % Track glucagon application
bolus_applied = zeros(size(time)); % Track bolus application

% Apply effects of basal insulin, glucagon, and bolus insulin
for i = 1:num_intervals
    % Apply basal insulin effect
    glucose_levels_combined(i) = glucose_levels_combined(i) + basal_effect;
    
    % Apply glucagon effect when glucose is below hypoglycemia threshold
    if glucose_levels_combined(i) < threshold_hypo
        glucose_levels_combined(i) = glucose_levels_combined(i) + glucagon_effect;
        glucagon_applied(i) = glucose_levels_combined(i); % Record glucagon impact
    end

    % Apply bolus insulin effect when glucose exceeds bolus threshold
    if glucose_levels_combined(i) > bolus_threshold
        glucose_levels_combined(i) = glucose_levels_combined(i) + bolus_effect;
        bolus_applied(i) = glucose_levels_combined(i); % Record bolus impact
    end
end

% Clip glucose levels to a realistic range
glucose_levels_combined = max(50, min(250, glucose_levels_combined));

% Visualize the glucose data
figure;
plot(time, glucose_levels, '-o', 'LineWidth', 1.5, 'DisplayName', 'Without Intervention');
hold on;
plot(time, glucose_levels_combined, '--', 'LineWidth', 1.5, 'DisplayName', 'With Combined Interventions');

% Highlight glucagon application points
scatter(time(glucagon_applied > 0), glucagon_applied(glucagon_applied > 0), 80, 'green', 'x', 'DisplayName', 'Glucagon Impact');

% Highlight bolus application points
scatter(time(bolus_applied > 0), bolus_applied(bolus_applied > 0), 80, 'red', 'o', 'DisplayName', 'Bolus Insulin Impact');

% Highlight thresholds
line([0, 24], [threshold_hypo, threshold_hypo], 'Color', 'blue', 'LineStyle', '--', 'LineWidth', 1.5, 'DisplayName', 'Hypoglycemia Threshold');
line([0, 24], [threshold_hyper, threshold_hyper], 'Color', 'red', 'LineStyle', '--', 'LineWidth', 1.5, 'DisplayName', 'Hyperglycemia Threshold');

% Add labels and legend
title('Glucose Levels with Combined Interventions');
xlabel('Time (hours)');
ylabel('Glucose Level (mg/dL)');
legend('Location', 'best');
grid on;

% Adjust axes
xlim([0 24]);
ylim([50 250]);
