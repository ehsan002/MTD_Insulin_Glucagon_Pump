% Glucose Data with Glucagon Impact - Simulation

% Parameters for simulation
num_intervals = 48; % Number of half-hour intervals in a day
threshold_hypo = 70; % Hypoglycemia threshold
threshold_hyper = 180; % Hyperglycemia threshold
basal_effect = -10; % Impact of basal insulin per interval
bolus_effect = -40; % Impact of bolus insulin on a glucose spike
glucagon_effect = 50; % Impact of glucagon on hypoglycemia

% Define custom glucose data for a specific scenario
time = linspace(0, 24, num_intervals); % Time in hours
glucose_levels = [
    65, 63, 60, 58, 57, 56, 55, 54, 50, 48, ... % Prolonged hypoglycemia
    85, 120, 115, 110, 108, 107, 106, 105, 140, 160, ... % Breakfast and snacks
    175, 185, 180, 178, 176, 175, 174, 173, 172, 170, ... % Lunch
    155, 150, 145, 140, 135, 130, 125, 120, 115, 110, ... % Afternoon and evening
    105, 100, 98, 96, 94, 92, 90, 88]; % Dinner and late night

% Smooth the custom data
glucose_levels = smoothdata(glucose_levels, 'gaussian', 5);

% Duplicate glucose levels for glucagon simulation
glucose_levels_glucagon = glucose_levels;
glucagon_applied = zeros(size(time)); % Track glucagon application

% Apply basal insulin effect and simulate glucagon when hypoglycemia occurs
for i = 1:num_intervals
    glucose_levels_glucagon(i) = glucose_levels_glucagon(i) + basal_effect;
    % Apply glucagon effect when glucose is below hypoglycemia threshold
    if glucose_levels_glucagon(i) < threshold_hypo
        glucose_levels_glucagon(i) = glucose_levels_glucagon(i) + glucagon_effect;
        glucagon_applied(i) = glucose_levels_glucagon(i); % Record glucagon impact
    end
end

% Clip glucose levels to a realistic range
glucose_levels_glucagon = max(50, min(250, glucose_levels_glucagon));

% Visualize the glucose data
figure;
plot(time, glucose_levels, '-o', 'LineWidth', 1.5);
hold on;
plot(time, glucose_levels_glucagon, '-x', 'LineWidth', 1.5);
scatter(time(glucagon_applied > 0), glucagon_applied(glucagon_applied > 0), 80, 'green', 'filled', 'DisplayName', 'Glucagon Impact');

% Highlight thresholds
line([0, 24], [threshold_hypo, threshold_hypo], 'Color', 'blue', 'LineStyle', '--', 'LineWidth', 1.5);
line([0, 24], [threshold_hyper, threshold_hyper], 'Color', 'red', 'LineStyle', '--', 'LineWidth', 1.5);

% Add labels and legend
title('Glucose Levels with Glucagon Impact');
xlabel('Time (hours)');
ylabel('Glucose Level (mg/dL)');
legend({'Without Intervention', 'With Glucagon', 'Glucagon Impact', 'Hypoglycemia Threshold', 'Hyperglycemia Threshold'}, 'Location', 'best');
grid on;

% Adjust axes
xlim([0 24]);
ylim([50 250]);
