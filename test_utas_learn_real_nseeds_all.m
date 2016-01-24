models = {@m1u @m2u @m3u @m4u};
nseeds = 10
nagen = 1000
ncriteria = 3

for i=1:length(models)
	model = models{i};
	modelname = func2str(model);

	for na=10:10:100
		for nsegments=1:3
			for degree=1:3
				for continuity=0:degree-1
					if (nsegments == 1) && (continuity > 0)
						continue
					end
					fname = sprintf('%s-%dalt-%dsegs-%ddeg-%dcont.txt', ...
							modelname, na, nsegments, degree, ...
							continuity)
					test_utas_learn_real_nseeds(10, model, ncriteria, na, ...
								    nagen, nsegments, ...
								    degree, continuity, ...
								    fname);
				end
			end
		end
	end
end
