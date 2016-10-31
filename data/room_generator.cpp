#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fstream>
#include <iostream>
#include <math.h>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

int nb_r=10; //nombre de salles
int seed=1231;
int size_map=100; //taille de la carte où sont placées les salles
char* name="room.xml"; //nom du fichier de sortie
vector<int> room_abs; //absisse des salles
vector<int> room_ord; //ordonnee des salles
int** Mat=new int*[nb_r+1];

/*Read parameters from command line*/
/*NOTE: Complete parameter list*/
void read_parameters(int argc, char *argv[]){
	int i;
	if(argc<=1) {
		cout<<"valeurs par defaut: nbr=10; name=room.xml"<<endl;
		nb_r=10;
	}
	for(i=1;i<argc;i++){
		if(strcmp(argv[i], "--seed") == 0){
			seed=atoi(argv[i+1]);
			i+=1;
		}else if(strcmp(argv[i], "--nbr") == 0){
			nb_r=atoi(argv[i+1]);
			i+=1;
		}else if(strcmp(argv[i], "--name") == 0){
			name=argv[i+1];	
			i+=1;
		}else{
			printf("\nERROR: parameter %s not recognized.\n",argv[i]);
			exit( EXIT_FAILURE );
		}
	}
}

void init(int nbr){
	for(int i=0;i<nbr;i++){
		room_abs.push_back(-1);
		room_ord.push_back(-1);
	}

    for(int i=0;i<nb_r;i++){
        Mat[i]=new int[nb_r];
    }
    for(int i=0;i<nb_r;i++){
        for(int j=0;j<nb_r;j++){
            Mat[i][j]=0;
        }
    }
}

void choice_coord(int nbr){	
	int r1=0;
	int r2=0;
	for(int i=1;i<nbr;i++){
		r1=rand()%(size_map);
		r2=rand()%(size_map);
		room_abs[i]=r1;
		room_ord[i]=r2;
	}
}

void update_mat(int nbr){
	for(int i=1;i<nb_r;i++){
		for(int j=i+1;j<nb_r;j++){
			Mat[i][j]=sqrt((room_ord[j]-room_ord[i])*(room_ord[j]-room_ord[i])+(room_abs[j]-room_abs[i])*(room_abs[j]-room_abs[i]));
			Mat[j][i]=Mat[i][j];
		}
	}
}

int main(int argc, char* argv[])
{
	read_parameters(argc, argv);
	srand(seed);
	nb_r=nb_r+1;
	init(nb_r);
	choice_coord(nb_r);
	update_mat(nb_r);
	fstream f(name,ios::out);
	f<<"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"<<endl;
	f<<"<room_list>"<<endl;
	f<<"	<room_number>"<<nb_r<<"</room_number>"<<endl;
	for(int i=0;i<nb_r;i++){
		f<<"	<room>"<<endl;
		f<<"		<id>"<<i<<"</id>"<<endl;
		f<<"		<distances_list>"<<endl;
		for(int j=0;j<nb_r;j++){
			f<<"			<room>"<<endl;
			f<<"				<id>"<<j<<"</id>"<<endl;
			f<<"				<distance>"<<Mat[i][j]<<"</distance>"<<endl;
			f<<"			</room>"<<endl;
		}
		f<<"		</distances_list>"<<endl;
		f<<"	</room>"<<endl;
	}
	f<<"</room_list>"<<endl;
	f.close();
	cout<<"fini"<<endl;
    return 0;
}
