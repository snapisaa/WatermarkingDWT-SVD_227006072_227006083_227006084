classdef gui < handle
    properties
        Logic
        Fig
        SourceImageAxes
        WMImageAxes
        WatermarkedImageAxes
        ExtractedImageAxes
        ExtractedFromAttackedAxes
        AttackTypeDropdown
        EmbedButton
        ExtractButton
        ExtractFromAttackedButton
    end
    methods
        function this = gui
            this.Logic = logic();
            this.createUI();
        end
        
        function createUI(this)
    this.Fig = figure('Name', 'Watermarking GUI', 'Position', [100, 100, 1200, 600]);
    
    % Source Image
    this.SourceImageAxes = axes('Units', 'Pixels', 'Position', [50, 300, 256, 256]);
    uicontrol('Style', 'text', 'String', 'Source Image', 'Position', [120, 280, 100, 20]);
    
    % Watermark Image
    this.WMImageAxes = axes('Units', 'Pixels', 'Position', [350, 300, 256, 256]);
    uicontrol('Style', 'text', 'String', 'Watermark Image', 'Position', [420, 280, 100, 20]);
    
    % Watermarked Image
    this.WatermarkedImageAxes = axes('Units', 'Pixels', 'Position', [650, 300, 256, 256]);
    uicontrol('Style', 'text', 'String', 'Watermarked Image', 'Position', [720, 280, 150, 20]);
    
    % Extracted Watermark
    this.ExtractedImageAxes = axes('Units', 'Pixels', 'Position', [950, 300, 256, 256]);
    uicontrol('Style', 'text', 'String', 'Extracted Watermark', 'Position', [1020, 280, 150, 20]);
    
    % Extracted from Attacked Image
    this.ExtractedFromAttackedAxes = axes('Units', 'Pixels', 'Position', [650, 50, 256, 256]);
    uicontrol('Style', 'text', 'String', 'Extracted from Attacked Image', 'Position', [720, 30, 200, 20]);
    
    % Attack Type Dropdown
    uicontrol('Style', 'text', 'String', 'Attack Type', 'Position', [420, 240, 100, 20]);
    this.AttackTypeDropdown = uicontrol('Style', 'popupmenu', 'String', {'None', 'Crop', 'Noise', 'JPEG'}, 'Position', [420, 220, 100, 20]);
    
    % Buttons
    uicontrol('Style', 'pushbutton', 'String', 'Embed', 'Position', [50, 200, 100, 30], 'Callback', @(src, event) this.embedCallback());
    uicontrol('Style', 'pushbutton', 'String', 'Extract', 'Position', [50, 150, 100, 30], 'Callback', @(src, event) this.extractCallback());
    uicontrol('Style', 'pushbutton', 'String', 'Extract from Attacked', 'Position', [420, 150, 150, 30], 'Callback', @(src, event) this.extractFromAttackedCallback());
    
    % Load Image Buttons
    uicontrol('Style', 'pushbutton', 'String', 'Load Source Image', 'Position', [50, 100, 150, 30], 'Callback', @(src, event) this.loadSourceImage());
    uicontrol('Style', 'pushbutton', 'String', 'Load Watermark Image', 'Position', [420, 100, 150, 30], 'Callback', @(src, event) this.loadWatermarkImage());
end

        
        function loadSourceImage(this)
            [file, path] = uigetfile({'*.jpg;*.png;*.bmp', 'Image Files'});
            if isequal(file, 0)
                return;
            end
            sourceFile = fullfile(path, file);
            this.Logic.initializeSource(sourceFile, 'Grayscale');
            imshow(this.Logic.SourceImage, 'Parent', this.SourceImageAxes);
        end
        
        function loadWatermarkImage(this)
            [file, path] = uigetfile({'*.jpg;*.png;*.bmp', 'Image Files'});
            if isequal(file, 0)
                return;
            end
            wmFile = fullfile(path, file);
            alteredWM = this.Logic.initializeWM(wmFile, 'Grayscale');
            imshow(alteredWM, 'Parent', this.WMImageAxes);
        end
        
        function embedCallback(this)
            alpha = 0.1; % Example alpha value, you can add UI component to set it
            this.Logic.embed(alpha);
            imshow(this.Logic.WatermarkedImage, 'Parent', this.WatermarkedImageAxes);
        end
        
        function extractCallback(this)
            extractedImage = this.Logic.extract();
            imshow(extractedImage, 'Parent', this.ExtractedImageAxes);
        end
        
        function extractFromAttackedCallback(this)
            attackType = this.AttackTypeDropdown.String{this.AttackTypeDropdown.Value};
            extractedImage = this.Logic.extractFromAttacked(attackType);
            imshow(extractedImage, 'Parent', this.ExtractedFromAttackedAxes);
        end
    end
end
