%test_utap_perfs([50:50:500], [5, 10], 'UTAP', [3 7], [0], 10, 'ctime-exp1.txt')
%test_utap_perfs([200, 500], [3:10], 'UTAP', [0], [3 7], 10, 'ctime-exp2.txt')
%test_utap_perfs([200, 500], [5, 10], 'UTAP', [0], [3:7], 10, 'ctime-exp3.txt')
%test_utap_perfs([200, 500], [5, 10], 'UTA', [3:10], [0], 10, 'ctime-exp4.txt')

%test_utadisp_perfs([50:50:500], [5, 10], [2, 5], 'UTADISP', [3 7], 10, 'utadisp-ctime-exp1.txt')
%test_utadisp_perfs([200, 500], [3:10], [2, 5], 'UTADISP', [3 7], 10, 'utadisp-ctime-exp2.txt')
%test_utadisp_perfs([200, 500], [5, 10], [2, 5], 'UTADISP', [3:7], 10, 'utadisp-ctime-exp3.txt')
%test_utadisp_perfs([200, 500], [5, 10], [2:7], 'UTADISP', [3 7], 10, 'utadisp-ctime-exp4.txt')
%test_utadisp_perfs([200 500], [5, 10], [2, 5], 'UTADIS', [3:10], 10, 'utadisp-ctime-exp5.txt')

%test_utadisp_perfs([10:10:100], [5, 10], [2, 5], 'UTADISP', [3 7], 10, 'utadisp-mretriev-exp4.txt')

%test_utap_perfs([20 100], [3:10], 'UTAP', [0], [3 7], 10, 'mretriev-exp5.txt')
%test_utap_perfs([20 100], [5 10], 'UTAP', [0], [3:7], 10, 'mretriev-exp6.txt')
%
%test_utadisp_perfs([100 200], [3:10], [2 5], 'UTADISP', [3 7], 10, 'utadisp-mretriev-exp8.txt')
%test_utadisp_perfs([100 200], [5 10], [2 5], 'UTADISP', [3:7], 10, 'utadisp-mretriev-exp9.txt')
%test_utadisp_perfs([100 200], [5 10], [2:7], 'UTADISP', [3 7], 10, 'utadisp-mretriev-exp10.txt')

%test_utap_perfs([100 200], [3:10], 'UTAP', [0], [3 7], 10, 'mretriev-exp8.txt')
%test_utap_perfs([100 200], [5 10], 'UTAP', [0], [3:7], 10, 'mretriev-exp9.txt')
test_utap_perfs([100 200], [5 10], 'UTAP',[0],  [3 7], 10, 'mretriev-exp10.txt')
quit
>>>>>>> Stashed changes
