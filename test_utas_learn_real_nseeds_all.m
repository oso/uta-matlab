models = {@m1u @m2u @m3u @m4u};
nseeds = 10
nagen = 1000
ncriteria = 3

for i=1:length(models)
	model = models{i};
	modelname = func2str(model);

	for nsegments=1:3
		for degree=1:3
			continuity = degree - 1;
			fname = sprintf('%s-%dsegs-%ddeg-%dcont.txt', ...
					modelname, nsegments, degree, ...
					continuity)
			test_utas_learn_real_nseeds(10, model, 3, 10, ...
						    nagen, nsegments, ...
						    degree, continuity, ...
						    fname);
		end
	end
end
