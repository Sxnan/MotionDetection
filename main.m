folders = dir('./DataSets');
threshold = 30;
alpha = 0.5;
gamma = 26;

for i=1:size(folders, 1)
    if (folders(i).name(1) == '.')
        continue
    end
    fprintf("%s | %s\n", [folders(i).folder, '/', folders(i).name], folders(i).name);
    main_loop([folders(i).folder, '/', folders(i).name], folders(i).name, threshold, alpha, gamma);
end

%different threshold on ArenaA
folder = './DataSets/ArenaA';
main_loop(folder, 'ArenaA_threshold_5', 5, alpha, gamma);
main_loop(folder, 'ArenaA_threshold_100', 100, alpha, gamma);

%different alpha on ArenaA
folder = './DataSets/ArenaA';
imgs = load_imgs(folder);
alphas = [0 0.1 0.5 0.9 1];
for i=1:size(alphas, 2)
    result_ABG = ABG(imgs, threshold, alphas(i));
    save(result_ABG, ['ArenaA_alpha_', sprintf('%f',alphas(i))]);
end

%different gamma on ArenaA
folder = './DataSets/ArenaA';
imgs = load_imgs(folder);
gammas = [5 26 100];
for i=1:size(gammas, 2)
    result_PFD = PFD(imgs, threshold, gammas(i));
    save(result_PFD, ['ArenaA_decay_', sprintf('%d',gammas(i))]);
end


%main_loop
function main_loop(folder, dataset_name, threshold, alpha, gamma)

    imgs = load_imgs(folder);

    %Simple Background Subtraction
    results_SBG = SBG(imgs, threshold);
    
    %Simple Frame Differencing
    results_SFD = SFD(imgs, threshold);
    
    %Adaptive Background Subtraction
    results_ABG = ABG(imgs, threshold, alpha);
    
    %Persistence Frame Differencing
    results_PFD = PFD(imgs, threshold, gamma);

    [m, n, o] = size(results_SBG);
    results = zeros(m*2, n*2, o);

    for i = 1:o
        results(:,:,i) = [results_SBG(:,:,i) results_SFD(:,:,i); results_ABG(:,:,i) results_PFD(:,:,i)];
    end

    save(results, dataset_name);
end

%load imgs
function imgs = load_imgs(folder)
    %list all img
    files = dir(folder);
    
    %remove invalid
    i = 1;
    while(i <= size(files, 1))
        if (isempty(regexp(files(i).name, '.*\.(jpg|png|jpeg)$', 'once')))
            files(i) = [];
        else
            i = i+1;
        end
    end
    
    im = imread([files(3).folder,'/', files(3).name]);
    [n, m, ~] = size(im);
    imgs = zeros(n, m, size(files, 1)-2);
    
    %get img size
    for i = 1:size(files, 1)
        img = imread([files(i).folder,'/', files(i).name]);
        img = rgb2gray(img);
        imgs(:,:,i) = img;
    end
end

%save results
function save(results, dataset_name)
    if ~exist('result', 'dir')
        mkdir('result');
    end
    
    if ~exist(['result', '/', dataset_name], 'dir')
        mkdir(['result', '/', dataset_name])
    end
    
    %save as images
    for i = 1:size(results, 3)
        filename = ['result', '/', dataset_name, '/', sprintf('%03d',i), '.png'];
        imwrite(results(:,:,i), filename);
    end
    
    %save as video
    outputVideo = VideoWriter(['result', '/', dataset_name, '/', dataset_name]);
    open(outputVideo);
    for i = 1:size(results, 3)
        writeVideo(outputVideo, results(:,:,i));
    end
    close(outputVideo);
end

