function khesh = kheshFaila(putKFailu)
% Рассчитывает контрольную сумму SHA-256 для набора данных.

if nargin < 1 || strlength(string(putKFailu)) == 0 || ~isfile(putKFailu)
    khesh = "";
    return;
end

fid = fopen(putKFailu, 'r');
assert(fid > 0, 'Не удалось открыть набор данных для расчета хэша.');
ochistka = onCleanup(@() fclose(fid));
bytes = fread(fid, inf, '*uint8');

digest = java.security.MessageDigest.getInstance('SHA-256');
digest.update(bytes);
hashBytes = typecast(digest.digest(), 'uint8');
khesh = lower(join(string(dec2hex(hashBytes, 2)), ""));
khesh = char(khesh);
end
