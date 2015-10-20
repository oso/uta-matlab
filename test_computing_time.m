clear;
test_utap_perfs([50:50:500], [5, 10], 'UTAP', [3 7], [0], 10, 'ctime-exp1.txt')
clear;
test_utap_perfs([200, 500], [3:10], 'UTAP', [0], [3 7], 10, 'ctime-exp2.txt')
clear;
test_utap_perfs([200, 500], [5, 10], 'UTAP', [0], [3:7], 10, 'ctime-exp3.txt')
clear;
test_utap_perfs([200, 500], [5, 10], 'UTA', [3:10], [0], 10, 'ctime-exp4.txt')
