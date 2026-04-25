function formatMap = dataFlashFormatMap()
% Возвращает карту форматов DataFlash для разбора полезной нагрузки.

formatMap = containers.Map('KeyType', 'char', 'ValueType', 'any');

formatMap('b') = makeEntry(1, 'int8', 1, false, "целое со знаком 8 бит");
formatMap('B') = makeEntry(1, 'uint8', 1, false, "целое без знака 8 бит");
formatMap('h') = makeEntry(2, 'int16', 1, false, "целое со знаком 16 бит");
formatMap('H') = makeEntry(2, 'uint16', 1, false, "целое без знака 16 бит");
formatMap('i') = makeEntry(4, 'int32', 1, false, "целое со знаком 32 бит");
formatMap('I') = makeEntry(4, 'uint32', 1, false, "целое без знака 32 бит");
formatMap('f') = makeEntry(4, 'single', 1, false, "число одинарной точности");
formatMap('d') = makeEntry(8, 'double', 1, false, "число двойной точности");
formatMap('n') = makeEntry(4, 'char', 1, true, "строка 4 байта");
formatMap('N') = makeEntry(16, 'char', 1, true, "строка 16 байт");
formatMap('Z') = makeEntry(64, 'char', 1, true, "строка 64 байта");
formatMap('c') = makeEntry(2, 'int16', 0.01, false, "масштабируемое целое со знаком 16 бит");
formatMap('C') = makeEntry(2, 'uint16', 0.01, false, "масштабируемое целое без знака 16 бит");
formatMap('e') = makeEntry(4, 'int32', 0.01, false, "масштабируемое целое со знаком 32 бит");
formatMap('E') = makeEntry(4, 'uint32', 0.01, false, "масштабируемое целое без знака 32 бит");
formatMap('L') = makeEntry(4, 'int32', 1e-7, false, "географическая координата");
formatMap('M') = makeEntry(1, 'uint8', 1, false, "код режима");
formatMap('q') = makeEntry(8, 'int64', 1, false, "целое со знаком 64 бит");
formatMap('Q') = makeEntry(8, 'uint64', 1, false, "целое без знака 64 бит");
end

function entry = makeEntry(sizeBytes, matlabType, scale, isText, description)
entry = struct();
entry.size_bytes = sizeBytes;
entry.matlab_type = matlabType;
entry.scale = scale;
entry.is_text = isText;
entry.description = description;
end
