function print_m_file(fname)

if ~contains(fname, '\')
    fname = fullfile(pwd, fname);
end

if ~exist(fname, 'file')
    error('MATLAB:print_m_file', 'File not found!');
end

h = actxserver('Word.Application');
h.Documents.Open(fname);
h.Visible = 1;
h.Run('add_my_header', sprintf('%s %s', datestr(now), fname)) 

end
