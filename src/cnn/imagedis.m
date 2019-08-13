function imagedis(m)
    m=reshape(m,28,28)';
    figure  % plot images                                        
    colormap(gray)
    imagesc(m)
end