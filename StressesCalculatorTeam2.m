classdef StressesCalculatorTeam2 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        StressesCalculatorTeam2UIFigure  matlab.ui.Figure
        OutputparametersPanel       matlab.ui.container.Panel
        PrincipalStressesPanel      matlab.ui.container.Panel
        Theta_p2EditField           matlab.ui.control.NumericEditField
        Theta_p2EditFieldLabel      matlab.ui.control.Label
        Theta_p1EditField           matlab.ui.control.NumericEditField
        Theta_p1EditFieldLabel      matlab.ui.control.Label
        Sigma2EditField             matlab.ui.control.NumericEditField
        Sigma2EditFieldLabel        matlab.ui.control.Label
        Sigma1EditField             matlab.ui.control.NumericEditField
        Sigma1EditFieldLabel        matlab.ui.control.Label
        MaximumShearStressPanel     matlab.ui.container.Panel
        Theta_s2EditField           matlab.ui.control.NumericEditField
        Theta_s2EditFieldLabel      matlab.ui.control.Label
        Theta_s1EditField           matlab.ui.control.NumericEditField
        Theta_s1EditFieldLabel      matlab.ui.control.Label
        MaximumShearEditField       matlab.ui.control.NumericEditField
        MaximumShearEditFieldLabel  matlab.ui.control.Label
        RotationStressesPanel       matlab.ui.container.Panel
        Shear_x1y1EditField         matlab.ui.control.NumericEditField
        Shear_x1y1EditFieldLabel    matlab.ui.control.Label
        Sigma_y1EditField           matlab.ui.control.NumericEditField
        Sigma_y1EditFieldLabel      matlab.ui.control.Label
        Sigma_x1EditField           matlab.ui.control.NumericEditField
        Sigma_x1EditFieldLabel      matlab.ui.control.Label
        CalculateParametersDrawCircleButton  matlab.ui.control.Button
        InputParametersPanel        matlab.ui.container.Panel
        RotationAngleEditField      matlab.ui.control.NumericEditField
        RotationAngleLabel          matlab.ui.control.Label
        Shear_xyxyEditField         matlab.ui.control.NumericEditField
        ShearLabel                  matlab.ui.control.Label
        Sigma_yEditField            matlab.ui.control.NumericEditField
        Sigma_yEditFieldLabel       matlab.ui.control.Label
        Sigma_xEditField            matlab.ui.control.NumericEditField
        Sigma_xEditFieldLabel       matlab.ui.control.Label
        UIAxes                      matlab.ui.control.UIAxes
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            movegui(app.StressesCalculatorTeam2UIFigure, 'center');
            app.InputParametersPanel.BorderColor = [0.09,0.42,0.53];
            app.OutputparametersPanel.BorderColor = [0.09,0.42,0.53];
            app.RotationStressesPanel.BorderColor = [0.09,0.42,0.53];
            app.MaximumShearStressPanel.BorderColor = [0.09,0.42,0.53];
            app.PrincipalStressesPanel.BorderColor = [0.09,0.42,0.53];
        end

        % Button pushed function: CalculateParametersDrawCircleButton
        function CalculateParametersDrawCircleButtonPushed(app, event)
            % Inputs:
            Sigma_x = app.Sigma_xEditField.Value; 
            Sigma_y = app.Sigma_yEditField.Value;
            Shear = app.Shear_xyxyEditField.Value;
            RotationAngle = app.RotationAngleEditField.Value;
            
            % Calculations:
            Sigma_x1 = ((Sigma_x+Sigma_y)/2) + (((Sigma_x-Sigma_y)/2)*cosd(2*RotationAngle)) + (Shear*sind(2*RotationAngle));
            Sigma_y1 = ((Sigma_x+Sigma_y)/2) - (((Sigma_x-Sigma_y)/2)*cosd(2*RotationAngle)) - (Shear*sind(2*RotationAngle));
            Shear_xy = ((-(Sigma_x-Sigma_y)/2)*sind(2*RotationAngle)) + (Shear*cosd(2*RotationAngle));
            Sigma1 = ((Sigma_x+Sigma_y)/2) + sqrt((((Sigma_x-Sigma_y)/2)^2)+ Shear^2);
            Sigma2 = ((Sigma_x+Sigma_y)/2) - sqrt((((Sigma_x-Sigma_y)/2)^2)+ Shear^2);
            a=Sigma_x-Sigma_y;
            b=Shear;
            c=2*(b/a);
            d=atand(c);
            Theta_p1=d/2;
            Theta_p2 = Theta_p1+90;
            s = atand(-a/(2*b));
            Theta_s1 = s/2;
            Theta_s2 = Theta_s1 + 90;
            MaximumShear = sqrt((((Sigma_x-Sigma_y)/2)^2)+ Shear^2);
            
            % Output:
            app.Sigma_x1EditField.Value = Sigma_x1;
            app.Sigma_y1EditField.Value = Sigma_y1;
            app.Shear_x1y1EditField.Value = Shear_xy;
            app.Sigma1EditField.Value = Sigma1;
            app.Sigma2EditField.Value = Sigma2;
            app.Theta_p1EditField.Value = Theta_p1;
            app.Theta_p2EditField.Value = Theta_p2;
            app.MaximumShearEditField.Value = MaximumShear;
            app.Theta_s1EditField.Value = Theta_s1;
            app.Theta_s2EditField.Value = Theta_s2;

            % Mohr's Circle:

            % Resetting Axes
            cla(app.UIAxes);

            % Computing Radius and Center of the circle
            R=sqrt((a/2)^2+Shear^2);
            C=(Sigma_x+Sigma_y)/2;
            
            % Customize axes labels and properties
            xlabel(app.UIAxes, 'Sigma');
            ylabel(app.UIAxes, 'Shear Stress');
            
            % Fix aspect ratio to ensure circle looks correct
            axis(app.UIAxes, 'equal');

            % Calculate the limits for the y axis
            yMin = -R;    % Minimum y-coordinate (assuming center at y=0)
            yMax = R;     % Maximum y-coordinate (assuming center at y=0)
            
            % Set the limits of the y axis to allow for a margin above and
            % below the circle
            margin = 0.1 * R; 
            ylim(app.UIAxes, [yMin - margin, yMax + margin]);

            
            % Holding app.UIAxest to allow overlapping of plotted points
            hold(app.UIAxes, 'on');
            
            % Add diameters for principal stresses and initial stress state
            plot(app.UIAxes, [Sigma_x, Sigma_y], [Shear, -Shear], 'r');
            plot(app.UIAxes, [Sigma_x1, Sigma_y1], [Shear_xy, -Shear_xy], 'g');
            
            % Generate angles for drawing the circle
            theta = linspace(0, 2*pi, 100);
            
            % Calculate x and y coordinates of the circle
            x = C + R * cos(theta);
            y = R * sin(theta);
            
            % Plot the circle on the UIAxes
            plot(app.UIAxes, x, y, 'k', 'LineWidth', 2);
            
            % Enable grid for better visualization
            grid(app.UIAxes, 'on');
            
            % Release the hold on app.UIAxes
            hold(app.UIAxes, 'off');

            % Turn Visibility on
            if app.StressesCalculatorTeam2UIFigure.Position(3) == 320
                app.OutputparametersPanel.Visible = "on";
                app.StressesCalculatorTeam2UIFigure.Position = [0,0,629,480];
                movegui(app.StressesCalculatorTeam2UIFigure, 'center');
                app.InputParametersPanel.Position = [31,281,260,170];
                app.OutputparametersPanel.Position = [341, 31, 260, 420];
                app.CalculateParametersDrawCircleButton.Position = [56, 249, 212, 23];
                app.UIAxes.Position = [21, 33, 300, 208];
                app.UIAxes.PlotBoxAspectRatio = [1,0.8566176470588235,0.8566176470588235];
                app.UIAxes.Visible = "on";
                app.UIAxes.Toolbar.Visible = "on";
            end
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Get the file path for locating images
            pathToMLAPP = fileparts(mfilename('fullpath'));

            % Create StressesCalculatorTeam2UIFigure and hide until all components are created
            app.StressesCalculatorTeam2UIFigure = uifigure('Visible', 'off');
            app.StressesCalculatorTeam2UIFigure.AutoResizeChildren = 'off';
            app.StressesCalculatorTeam2UIFigure.Color = [0.9647 0.9451 0.9451];
            app.StressesCalculatorTeam2UIFigure.Position = [0 0 320 260];
            app.StressesCalculatorTeam2UIFigure.Name = 'Stresses Calculator - Team 2';
            app.StressesCalculatorTeam2UIFigure.Icon = fullfile(pathToMLAPP, 'calculator.png');
            app.StressesCalculatorTeam2UIFigure.Resize = 'off';

            % Create UIAxes
            app.UIAxes = uiaxes(app.StressesCalculatorTeam2UIFigure);
            title(app.UIAxes, 'Mohr''s Circle')
            xlabel(app.UIAxes, 'Sigma_x1')
            ylabel(app.UIAxes, 'y''')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Toolbar.Visible = 'off';
            app.UIAxes.FontName = 'Nunito';
            app.UIAxes.YDir = 'reverse';
            app.UIAxes.XAxisLocation = 'origin';
            app.UIAxes.XColor = [0.0902 0.4196 0.5294];
            app.UIAxes.YAxisLocation = 'origin';
            app.UIAxes.YColor = [0.0902 0.4196 0.5294];
            app.UIAxes.ZColor = [0.0902 0.4196 0.5294];
            app.UIAxes.Color = [0.9647 0.9451 0.9451];
            app.UIAxes.GridColor = [0.0902 0.4196 0.5294];
            app.UIAxes.Visible = 'off';
            app.UIAxes.Position = [11 1 300 10];

            % Create InputParametersPanel
            app.InputParametersPanel = uipanel(app.StressesCalculatorTeam2UIFigure);
            app.InputParametersPanel.AutoResizeChildren = 'off';
            app.InputParametersPanel.ForegroundColor = [0.0902 0.4196 0.5294];
            app.InputParametersPanel.TitlePosition = 'centertop';
            app.InputParametersPanel.Title = 'Input Parameters';
            app.InputParametersPanel.BackgroundColor = [0.6863 0.8275 0.8863];
            app.InputParametersPanel.FontName = 'Nunito';
            app.InputParametersPanel.FontWeight = 'bold';
            app.InputParametersPanel.FontSize = 14;
            app.InputParametersPanel.Position = [31 61 260 170];

            % Create Sigma_xEditFieldLabel
            app.Sigma_xEditFieldLabel = uilabel(app.InputParametersPanel);
            app.Sigma_xEditFieldLabel.HorizontalAlignment = 'right';
            app.Sigma_xEditFieldLabel.FontName = 'Nunito';
            app.Sigma_xEditFieldLabel.FontWeight = 'bold';
            app.Sigma_xEditFieldLabel.FontColor = [0.0902 0.4196 0.5294];
            app.Sigma_xEditFieldLabel.Position = [16 108 53 22];
            app.Sigma_xEditFieldLabel.Text = 'Sigma_x';

            % Create Sigma_xEditField
            app.Sigma_xEditField = uieditfield(app.InputParametersPanel, 'numeric');
            app.Sigma_xEditField.HorizontalAlignment = 'left';
            app.Sigma_xEditField.FontName = 'Nunito';
            app.Sigma_xEditField.FontColor = [0.0902 0.4196 0.5294];
            app.Sigma_xEditField.Position = [136 108 100 22];

            % Create Sigma_yEditFieldLabel
            app.Sigma_yEditFieldLabel = uilabel(app.InputParametersPanel);
            app.Sigma_yEditFieldLabel.HorizontalAlignment = 'right';
            app.Sigma_yEditFieldLabel.FontName = 'Nunito';
            app.Sigma_yEditFieldLabel.FontWeight = 'bold';
            app.Sigma_yEditFieldLabel.FontColor = [0.0902 0.4196 0.5294];
            app.Sigma_yEditFieldLabel.Position = [16 78 52 22];
            app.Sigma_yEditFieldLabel.Text = 'Sigma_y';

            % Create Sigma_yEditField
            app.Sigma_yEditField = uieditfield(app.InputParametersPanel, 'numeric');
            app.Sigma_yEditField.HorizontalAlignment = 'left';
            app.Sigma_yEditField.FontName = 'Nunito';
            app.Sigma_yEditField.FontColor = [0.0902 0.4196 0.5294];
            app.Sigma_yEditField.Position = [136 78 100 22];

            % Create ShearLabel
            app.ShearLabel = uilabel(app.InputParametersPanel);
            app.ShearLabel.HorizontalAlignment = 'right';
            app.ShearLabel.FontName = 'Nunito';
            app.ShearLabel.FontWeight = 'bold';
            app.ShearLabel.FontColor = [0.0902 0.4196 0.5294];
            app.ShearLabel.Position = [16 48 86 22];
            app.ShearLabel.Text = 'Shear_xy (τxy)';

            % Create Shear_xyxyEditField
            app.Shear_xyxyEditField = uieditfield(app.InputParametersPanel, 'numeric');
            app.Shear_xyxyEditField.HorizontalAlignment = 'left';
            app.Shear_xyxyEditField.FontName = 'Nunito';
            app.Shear_xyxyEditField.FontColor = [0.0902 0.4196 0.5294];
            app.Shear_xyxyEditField.Position = [136 48 100 22];

            % Create RotationAngleLabel
            app.RotationAngleLabel = uilabel(app.InputParametersPanel);
            app.RotationAngleLabel.HorizontalAlignment = 'center';
            app.RotationAngleLabel.FontName = 'Nunito';
            app.RotationAngleLabel.FontWeight = 'bold';
            app.RotationAngleLabel.FontColor = [0.0902 0.4196 0.5294];
            app.RotationAngleLabel.Position = [17 18 107 22];
            app.RotationAngleLabel.Text = 'Rotation Angle (θ)';

            % Create RotationAngleEditField
            app.RotationAngleEditField = uieditfield(app.InputParametersPanel, 'numeric');
            app.RotationAngleEditField.HorizontalAlignment = 'left';
            app.RotationAngleEditField.FontName = 'Nunito';
            app.RotationAngleEditField.FontColor = [0.0902 0.4196 0.5294];
            app.RotationAngleEditField.Position = [136 18 100 22];

            % Create CalculateParametersDrawCircleButton
            app.CalculateParametersDrawCircleButton = uibutton(app.StressesCalculatorTeam2UIFigure, 'push');
            app.CalculateParametersDrawCircleButton.ButtonPushedFcn = createCallbackFcn(app, @CalculateParametersDrawCircleButtonPushed, true);
            app.CalculateParametersDrawCircleButton.FontName = 'Nunito';
            app.CalculateParametersDrawCircleButton.FontWeight = 'bold';
            app.CalculateParametersDrawCircleButton.FontColor = [0.0902 0.4196 0.5294];
            app.CalculateParametersDrawCircleButton.Position = [56 29 212 23];
            app.CalculateParametersDrawCircleButton.Text = 'Calculate Parameters & Draw Circle';

            % Create OutputparametersPanel
            app.OutputparametersPanel = uipanel(app.StressesCalculatorTeam2UIFigure);
            app.OutputparametersPanel.AutoResizeChildren = 'off';
            app.OutputparametersPanel.ForegroundColor = [0.0902 0.4196 0.5294];
            app.OutputparametersPanel.TitlePosition = 'centertop';
            app.OutputparametersPanel.Title = 'Output parameters';
            app.OutputparametersPanel.Visible = 'off';
            app.OutputparametersPanel.BackgroundColor = [0.6863 0.8275 0.8863];
            app.OutputparametersPanel.FontName = 'Nunito';
            app.OutputparametersPanel.FontWeight = 'bold';
            app.OutputparametersPanel.FontSize = 14;
            app.OutputparametersPanel.Position = [341 -189 260 420];

            % Create RotationStressesPanel
            app.RotationStressesPanel = uipanel(app.OutputparametersPanel);
            app.RotationStressesPanel.AutoResizeChildren = 'off';
            app.RotationStressesPanel.ForegroundColor = [0.0902 0.4196 0.5294];
            app.RotationStressesPanel.TitlePosition = 'centertop';
            app.RotationStressesPanel.Title = 'Rotation Stresses';
            app.RotationStressesPanel.BackgroundColor = [0.6863 0.8275 0.8863];
            app.RotationStressesPanel.FontName = 'Nunito';
            app.RotationStressesPanel.FontWeight = 'bold';
            app.RotationStressesPanel.Position = [10 267 240 121];

            % Create Sigma_x1EditFieldLabel
            app.Sigma_x1EditFieldLabel = uilabel(app.RotationStressesPanel);
            app.Sigma_x1EditFieldLabel.HorizontalAlignment = 'right';
            app.Sigma_x1EditFieldLabel.FontName = 'Nunito';
            app.Sigma_x1EditFieldLabel.FontWeight = 'bold';
            app.Sigma_x1EditFieldLabel.FontColor = [0.0902 0.4196 0.5294];
            app.Sigma_x1EditFieldLabel.Position = [33 68 60 22];
            app.Sigma_x1EditFieldLabel.Text = 'Sigma_x1';

            % Create Sigma_x1EditField
            app.Sigma_x1EditField = uieditfield(app.RotationStressesPanel, 'numeric');
            app.Sigma_x1EditField.ValueDisplayFormat = '%.3f';
            app.Sigma_x1EditField.Editable = 'off';
            app.Sigma_x1EditField.HorizontalAlignment = 'left';
            app.Sigma_x1EditField.FontName = 'Nunito';
            app.Sigma_x1EditField.FontColor = [0.0902 0.4196 0.5294];
            app.Sigma_x1EditField.Position = [115 68 100 22];

            % Create Sigma_y1EditFieldLabel
            app.Sigma_y1EditFieldLabel = uilabel(app.RotationStressesPanel);
            app.Sigma_y1EditFieldLabel.HorizontalAlignment = 'right';
            app.Sigma_y1EditFieldLabel.FontName = 'Nunito';
            app.Sigma_y1EditFieldLabel.FontWeight = 'bold';
            app.Sigma_y1EditFieldLabel.FontColor = [0.0902 0.4196 0.5294];
            app.Sigma_y1EditFieldLabel.Position = [33 38 59 22];
            app.Sigma_y1EditFieldLabel.Text = 'Sigma_y1';

            % Create Sigma_y1EditField
            app.Sigma_y1EditField = uieditfield(app.RotationStressesPanel, 'numeric');
            app.Sigma_y1EditField.ValueDisplayFormat = '%.3f';
            app.Sigma_y1EditField.Editable = 'off';
            app.Sigma_y1EditField.HorizontalAlignment = 'left';
            app.Sigma_y1EditField.FontName = 'Nunito';
            app.Sigma_y1EditField.FontColor = [0.0902 0.4196 0.5294];
            app.Sigma_y1EditField.Position = [115 38 100 22];

            % Create Shear_x1y1EditFieldLabel
            app.Shear_x1y1EditFieldLabel = uilabel(app.RotationStressesPanel);
            app.Shear_x1y1EditFieldLabel.HorizontalAlignment = 'right';
            app.Shear_x1y1EditFieldLabel.FontName = 'Nunito';
            app.Shear_x1y1EditFieldLabel.FontWeight = 'bold';
            app.Shear_x1y1EditFieldLabel.FontColor = [0.0902 0.4196 0.5294];
            app.Shear_x1y1EditFieldLabel.Position = [33 8 70 22];
            app.Shear_x1y1EditFieldLabel.Text = 'Shear_x1y1';

            % Create Shear_x1y1EditField
            app.Shear_x1y1EditField = uieditfield(app.RotationStressesPanel, 'numeric');
            app.Shear_x1y1EditField.ValueDisplayFormat = '%.3f';
            app.Shear_x1y1EditField.Editable = 'off';
            app.Shear_x1y1EditField.HorizontalAlignment = 'left';
            app.Shear_x1y1EditField.FontName = 'Nunito';
            app.Shear_x1y1EditField.FontColor = [0.0902 0.4196 0.5294];
            app.Shear_x1y1EditField.Position = [115 8 100 22];

            % Create MaximumShearStressPanel
            app.MaximumShearStressPanel = uipanel(app.OutputparametersPanel);
            app.MaximumShearStressPanel.AutoResizeChildren = 'off';
            app.MaximumShearStressPanel.ForegroundColor = [0.0902 0.4196 0.5294];
            app.MaximumShearStressPanel.TitlePosition = 'centertop';
            app.MaximumShearStressPanel.Title = 'Maximum Shear Stress';
            app.MaximumShearStressPanel.BackgroundColor = [0.6863 0.8275 0.8863];
            app.MaximumShearStressPanel.FontName = 'Nunito';
            app.MaximumShearStressPanel.FontWeight = 'bold';
            app.MaximumShearStressPanel.Position = [11 8 240 91];

            % Create MaximumShearEditFieldLabel
            app.MaximumShearEditFieldLabel = uilabel(app.MaximumShearStressPanel);
            app.MaximumShearEditFieldLabel.HorizontalAlignment = 'right';
            app.MaximumShearEditFieldLabel.FontName = 'Nunito';
            app.MaximumShearEditFieldLabel.FontWeight = 'bold';
            app.MaximumShearEditFieldLabel.FontColor = [0.0902 0.4196 0.5294];
            app.MaximumShearEditFieldLabel.Position = [1 38 94 22];
            app.MaximumShearEditFieldLabel.Text = 'Maximum Shear';

            % Create MaximumShearEditField
            app.MaximumShearEditField = uieditfield(app.MaximumShearStressPanel, 'numeric');
            app.MaximumShearEditField.ValueDisplayFormat = '%.3f';
            app.MaximumShearEditField.Editable = 'off';
            app.MaximumShearEditField.HorizontalAlignment = 'left';
            app.MaximumShearEditField.FontName = 'Nunito';
            app.MaximumShearEditField.FontColor = [0.0902 0.4196 0.5294];
            app.MaximumShearEditField.Position = [107 38 124 22];

            % Create Theta_s1EditFieldLabel
            app.Theta_s1EditFieldLabel = uilabel(app.MaximumShearStressPanel);
            app.Theta_s1EditFieldLabel.HorizontalAlignment = 'right';
            app.Theta_s1EditFieldLabel.FontName = 'Nunito';
            app.Theta_s1EditFieldLabel.FontWeight = 'bold';
            app.Theta_s1EditFieldLabel.FontColor = [0.0902 0.4196 0.5294];
            app.Theta_s1EditFieldLabel.Position = [1 8 56 22];
            app.Theta_s1EditFieldLabel.Text = 'Theta_s1';

            % Create Theta_s1EditField
            app.Theta_s1EditField = uieditfield(app.MaximumShearStressPanel, 'numeric');
            app.Theta_s1EditField.ValueDisplayFormat = '%.3f';
            app.Theta_s1EditField.Editable = 'off';
            app.Theta_s1EditField.HorizontalAlignment = 'left';
            app.Theta_s1EditField.FontName = 'Nunito';
            app.Theta_s1EditField.FontColor = [0.0902 0.4196 0.5294];
            app.Theta_s1EditField.Position = [60 8 57 22];

            % Create Theta_s2EditFieldLabel
            app.Theta_s2EditFieldLabel = uilabel(app.MaximumShearStressPanel);
            app.Theta_s2EditFieldLabel.HorizontalAlignment = 'right';
            app.Theta_s2EditFieldLabel.FontName = 'Nunito';
            app.Theta_s2EditFieldLabel.FontWeight = 'bold';
            app.Theta_s2EditFieldLabel.FontColor = [0.0902 0.4196 0.5294];
            app.Theta_s2EditFieldLabel.Position = [115 8 56 22];
            app.Theta_s2EditFieldLabel.Text = 'Theta_s2';

            % Create Theta_s2EditField
            app.Theta_s2EditField = uieditfield(app.MaximumShearStressPanel, 'numeric');
            app.Theta_s2EditField.ValueDisplayFormat = '%.3f';
            app.Theta_s2EditField.Editable = 'off';
            app.Theta_s2EditField.HorizontalAlignment = 'left';
            app.Theta_s2EditField.FontName = 'Nunito';
            app.Theta_s2EditField.FontColor = [0.0902 0.4196 0.5294];
            app.Theta_s2EditField.Position = [175 8 56 22];

            % Create PrincipalStressesPanel
            app.PrincipalStressesPanel = uipanel(app.OutputparametersPanel);
            app.PrincipalStressesPanel.AutoResizeChildren = 'off';
            app.PrincipalStressesPanel.ForegroundColor = [0.0902 0.4196 0.5294];
            app.PrincipalStressesPanel.TitlePosition = 'centertop';
            app.PrincipalStressesPanel.Title = 'Principal Stresses';
            app.PrincipalStressesPanel.BackgroundColor = [0.6863 0.8275 0.8863];
            app.PrincipalStressesPanel.FontName = 'Nunito';
            app.PrincipalStressesPanel.FontWeight = 'bold';
            app.PrincipalStressesPanel.Position = [10 109 240 151];

            % Create Sigma1EditFieldLabel
            app.Sigma1EditFieldLabel = uilabel(app.PrincipalStressesPanel);
            app.Sigma1EditFieldLabel.HorizontalAlignment = 'right';
            app.Sigma1EditFieldLabel.FontName = 'Nunito';
            app.Sigma1EditFieldLabel.FontWeight = 'bold';
            app.Sigma1EditFieldLabel.FontColor = [0.0902 0.4196 0.5294];
            app.Sigma1EditFieldLabel.Position = [29 100 47 22];
            app.Sigma1EditFieldLabel.Text = 'Sigma1';

            % Create Sigma1EditField
            app.Sigma1EditField = uieditfield(app.PrincipalStressesPanel, 'numeric');
            app.Sigma1EditField.ValueDisplayFormat = '%.3f';
            app.Sigma1EditField.Editable = 'off';
            app.Sigma1EditField.HorizontalAlignment = 'left';
            app.Sigma1EditField.FontName = 'Nunito';
            app.Sigma1EditField.FontColor = [0.0902 0.4196 0.5294];
            app.Sigma1EditField.Position = [115 100 100 22];

            % Create Sigma2EditFieldLabel
            app.Sigma2EditFieldLabel = uilabel(app.PrincipalStressesPanel);
            app.Sigma2EditFieldLabel.HorizontalAlignment = 'right';
            app.Sigma2EditFieldLabel.FontName = 'Nunito';
            app.Sigma2EditFieldLabel.FontWeight = 'bold';
            app.Sigma2EditFieldLabel.FontColor = [0.0902 0.4196 0.5294];
            app.Sigma2EditFieldLabel.Position = [29 69 47 22];
            app.Sigma2EditFieldLabel.Text = 'Sigma2';

            % Create Sigma2EditField
            app.Sigma2EditField = uieditfield(app.PrincipalStressesPanel, 'numeric');
            app.Sigma2EditField.ValueDisplayFormat = '%.3f';
            app.Sigma2EditField.Editable = 'off';
            app.Sigma2EditField.HorizontalAlignment = 'left';
            app.Sigma2EditField.FontName = 'Nunito';
            app.Sigma2EditField.FontColor = [0.0902 0.4196 0.5294];
            app.Sigma2EditField.Position = [115 69 100 22];

            % Create Theta_p1EditFieldLabel
            app.Theta_p1EditFieldLabel = uilabel(app.PrincipalStressesPanel);
            app.Theta_p1EditFieldLabel.HorizontalAlignment = 'right';
            app.Theta_p1EditFieldLabel.FontName = 'Nunito';
            app.Theta_p1EditFieldLabel.FontWeight = 'bold';
            app.Theta_p1EditFieldLabel.FontColor = [0.0902 0.4196 0.5294];
            app.Theta_p1EditFieldLabel.Position = [29 39 57 22];
            app.Theta_p1EditFieldLabel.Text = 'Theta_p1';

            % Create Theta_p1EditField
            app.Theta_p1EditField = uieditfield(app.PrincipalStressesPanel, 'numeric');
            app.Theta_p1EditField.ValueDisplayFormat = '%.3f';
            app.Theta_p1EditField.Editable = 'off';
            app.Theta_p1EditField.HorizontalAlignment = 'left';
            app.Theta_p1EditField.FontName = 'Nunito';
            app.Theta_p1EditField.FontColor = [0.0902 0.4196 0.5294];
            app.Theta_p1EditField.Position = [115 39 100 22];

            % Create Theta_p2EditFieldLabel
            app.Theta_p2EditFieldLabel = uilabel(app.PrincipalStressesPanel);
            app.Theta_p2EditFieldLabel.HorizontalAlignment = 'right';
            app.Theta_p2EditFieldLabel.FontName = 'Nunito';
            app.Theta_p2EditFieldLabel.FontWeight = 'bold';
            app.Theta_p2EditFieldLabel.FontColor = [0.0902 0.4196 0.5294];
            app.Theta_p2EditFieldLabel.Position = [29 9 57 22];
            app.Theta_p2EditFieldLabel.Text = 'Theta_p2';

            % Create Theta_p2EditField
            app.Theta_p2EditField = uieditfield(app.PrincipalStressesPanel, 'numeric');
            app.Theta_p2EditField.ValueDisplayFormat = '%.3f';
            app.Theta_p2EditField.Editable = 'off';
            app.Theta_p2EditField.HorizontalAlignment = 'left';
            app.Theta_p2EditField.FontName = 'Nunito';
            app.Theta_p2EditField.FontColor = [0.0902 0.4196 0.5294];
            app.Theta_p2EditField.Position = [115 9 100 22];

            % Show the figure after all components are created
            app.StressesCalculatorTeam2UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = StressesCalculatorTeam2

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.StressesCalculatorTeam2UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.StressesCalculatorTeam2UIFigure)
        end
    end
end