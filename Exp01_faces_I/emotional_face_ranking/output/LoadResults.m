load( 'Emotional_ranking_keren_25-May-2015_12h08m' );
m = response;

load( 'Emotional_ranking_Rotem_21-May-2015_17h26m' );
m(:,3) = response(:,2);

load('Emotional_ranking_Tom_21-May-2015_10h15m' );
m(:,4) = response(:,2);

load('Emotional_ranking_Tom_Salomon_21-May-2015_10h51m' );
m(:,5) = response(:,2);

load('Emotional_ranking_Yael_21-May-2015_09h38m' );
m(:,6) = response(:,2);

means = mean( m(:, 2:6)' )';
means = [ m(:, 1), means]