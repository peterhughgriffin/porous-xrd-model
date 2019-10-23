function fflush_stdout();

global Moctave

%fflush does not exist in Matlab but does exit in Octave
if Moctave
	fflush(stdout);
end

end
