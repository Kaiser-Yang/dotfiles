function date_translator(input, seg)
    if (input == "tt") then
        yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d %H:%M:%S") .. '+0800', ""))
    end
end
