#!/usr/bin/octave -qf 

arg_list = argv ();
numcolors=str2num(arg_list{1});
numpegs=str2num(arg_list{2});
numsamples =str2num(arg_list{3});

printf(" Colors %d Pegs %d Samples %d\n", numcolors, numpegs, numsamples );

samples = zeros(numsamples, numpegs);

for i=1:numsamples,
   check = 1;
   while (check),
      comb = 1+floor(rand(1,numpegs)*numcolors);
      keep = 1;
      j=1;
      while (j<i) && keep,
         keep = sum(samples(j,:)==comb)<numpegs;
         j = j + 1;
      end
      check = 1-keep;
   end
   samples(i,:) = comb;
end

fid = fopen(strcat('samples',num2str(numpegs),'_',num2str(numcolors),'.txt'),
'w');
for i=1:numsamples,
   for j=1:numpegs,
      fprintf(fid, '%d\t', samples(i,j));
   end
   fprintf(fid,'\n');
end
fclose(fid);
