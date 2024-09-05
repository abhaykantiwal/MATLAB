% Load and convert images T1 and T2 to double precision
image_T1 = double(imread("T1.jpg"));
image_T2 = double(imread("T2.jpg"));

% Get the size of image_T1
image_size = size(image_T1);
x = image_size(1);
y = image_size(2);

% Calculate the negative of image_T1
image_T3 = 255 - image_T1;

% Initialize arrays to store correlation and QMI values
correlation = zeros(1, 21);
qmi = zeros(1, 21);

% Iterate through different values of t (-10 to 10)
for t = -10:10
    q = zeros(image_size);

    % Shift and copy values from image_T2 to q based on t
    if t >= 0
        for i = 1:y - t
            q(:, i + t) = image_T2(:, i);
        end
    else  
        for i = -t + 1:y
            q(:, i + t) = image_T2(:, i);
        end
    end

    % Calculate standard deviations
    std_T1 = std2(image_T1);
    std_q = std2(q);

    % Initialize variables for correlation calculation
    sum_corr = 0;

    % Calculate correlation
    for i = 1:x * y
        sum_corr = sum_corr + (image_T1(i) - mean2(image_T1)) * (q(i) - mean2(q));
    end

    % Initialize variables for joint histogram and marginal distributions
    joint_histogram = zeros(26, 26);
    marginal_T1 = zeros(1, 26);
    marginal_q = zeros(1, 26);

    % Create joint histogram and calculate marginal distributions  
    for i = 1:x * y
        a = floor(image_T1(i) / 10) + 1;
        b = floor(q(i) / 10) + 1;
        joint_histogram(a, b) = joint_histogram(a, b) + 1;
    end  

    % Normalize joint histogram
    joint_histogram = joint_histogram / sum(joint_histogram, 'all');

    for i = 1:26  
        marginal_T1(1, i) = sum(joint_histogram(i, :));
        marginal_q(1, i) = sum(joint_histogram(:, i));
    end

    % Calculate QMI
    sum_qmi = 0;
    for i1 = 1:26
        for i2 = 1:26
            sum_qmi = sum_qmi + ((joint_histogram(i1, i2) - marginal_T1(1, i1) * marginal_q(1, i2))^2);
        end
    end

    % Calculate correlation and QMI values for this t
    correlation(1, t + 11) = sum_corr / (std_T1 * std_q * x * y);
    qmi(1, t + 11) = sum_qmi;
end

% Generate values of tx for plotting
tx = -10:1:10;

% Plot correlation between T1 and T2
figure;
subplot(2, 1, 1);
plot(tx, correlation);
title('Correlation between T1 and T2');

% Plot QMI between T1 and T2
subplot(2, 1, 2);
plot(tx, qmi);
title('QMI between T1 and T2');

% Finding dependence measures between T1 and inverted T1
correlation2 = zeros(1, 21);
qmi2 = zeros(1, 21);

% Iterate through different values of o (-10 to 10)
for o = -10:10
    q2 = zeros(image_size);

    % Shift and copy values from image_T3 to q2 based on o
    if o >= 0
        for i = 1:y - o
            q2(:, i + o) = image_T3(:, i);
        end
    else
        for i = -o + 1:y
            q2(:, i + o) = image_T3(:, i);
        end
    end

    % Calculate standard deviations
    std_T1_inverted = std2(image_T1);
    std_q2 = std2(q2);

    % Initialize variables for correlation calculation
    sum_corr2 = 0;

    % Calculate correlation
    for i = 1:x * y
        sum_corr2 = sum_corr2 + (image_T1(i) - mean2(image_T1)) * (q2(i) - mean2(q2));
    end

    % Initialize variables for joint histogram and marginal distributions
    joint_histogram2 = zeros(26, 26);
    marginal_T1_inverted = zeros(1, 26);
    marginal_q2 = zeros(1, 26);

    % Create joint histogram and calculate marginal distributions
    for i = 1:x * y
        c = floor(image_T1(i) / 10) + 1;
        d = floor(q2(i) / 10) + 1;
        joint_histogram2(c, d) = joint_histogram2(c, d) + 1;
    end

    % Normalize joint histogram
    joint_histogram2 = joint_histogram2 / sum(joint_histogram2, 'all');

    for i = 1:26
        marginal_T1_inverted(1, i) = sum(joint_histogram2(i, :));
        marginal_q2(1, i) = sum(joint_histogram2(:, i));
    end

    % Calculate QMI
    sum_qmi2 = 0;
    for i1 = 1:26
        for i2 = 1:26
            sum_qmi2 = sum_qmi2 + ((joint_histogram2(i1, i2) - marginal_T1_inverted(1, i1) * marginal_q2(1, i2))^2);
        end
    end

    % Calculate correlation and QMI values for this o
    correlation2(1, o + 11) = sum_corr2 / (std_T1_inverted * std_q2 * x * y);
    qmi2(1, o + 11) = sum_qmi2;
end

% Generate values of ty for plotting
ty = -10:1:10;

% Plot correlation between T1 and inverted T1
figure;
subplot(2, 1, 1);
plot(ty, correlation2);
title('Correlation between T1 and inverted T1');

% Plot QMI between T1 and inverted T1
subplot(2, 1, 2);
plot(ty, qmi2);
title('QMI between T1 and inverted T1');
