function saveFigures(savefolder, saveFig)


if saveFig == 1
    
    figHandles = findobj('Type', 'figure'); % Gather all figure handles
    set(figHandles, 'renderer', 'painters'); % Set renderer to 'painters' for proper further processing in Illustrator
    set(figHandles, 'Position', get(0, 'Screensize')); % Set figures to full screen size (easier to process images in Illustrator)
    
    for fi = 1:numel(figHandles)
        saveas(figHandles(fi), [savefolder, '\FPbars-',num2str(figHandles(fi).Number)], 'epsc'); % Save each figure as .EPSC file
    end
    
end


end