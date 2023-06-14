airpar.rir_type = 1;
airpar.room = 5;
airpar.head = 1;
airpar.rir_no = 2;
airpar.azimuth = 15;

airpar.channel = 1;
[h_left,air_info] = load_air(airpar);
airpar.channel = 0;
[h_right,air_info] = load_air(airpar);

figure,
subplot 211,plot(h_left)
subplot 212,plot(h_right)