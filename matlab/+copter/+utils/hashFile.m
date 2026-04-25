function hash = hashFile(filePath)
% Рассчитывает SHA-256 для файла.

if nargin < 1
    hash = "";
    return;
end

if strlength(string(filePath)) == 0 || ~isfile(filePath)
    hash = "";
    return;
end

fileId = fopen(filePath, 'r');
assert(fileId > 0, 'Не удалось открыть файл для расчета хэша.');
cleanup = onCleanup(@() fclose(fileId));
bytes = fread(fileId, inf, '*uint8');

digest = java.security.MessageDigest.getInstance('SHA-256');
digest.update(bytes);
hashBytes = typecast(digest.digest(), 'uint8');
hash = lower(join(string(dec2hex(hashBytes, 2)), ""));
hash = char(hash);
end
