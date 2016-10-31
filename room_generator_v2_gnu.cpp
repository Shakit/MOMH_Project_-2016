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

int nb_r=50; //nombre de salles
int seed=1231;
int size_map=100; //taille de la carte où sont placées les salles
vector<int> room_abs; //absisse des salles
vector<int> room_ord; //ordonnee des salles
char* name="room_gnu.dat"; //nom du fichier de sortie
int** Mat=new int*[nb_r+1];

//g++ room_generator_v2_gnu.cpp -o room_gnu.exe
// ./pref_gnu.exe --seed 123132132 --scr 10
//cree un fichier: room_gnu.dat

/*Read parameters from command line*/
/*NOTE: Complete parameter list*/
void read_parameters(int argc, char *argv[]){
	int i;
	if(argc<=1) {
		cout<<"valeurs par defaut: nbr=10; name=room_gnu.dat"<<endl;
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
	for(int i=0;i<nb_r;i++){
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
	//nb_r=nb_r+1;
	init(nb_r);
	choice_coord(nb_r);
	update_mat(nb_r);
	fstream f(name,ios::out);
	f<<"param nbs:= "<<nb_r<<";"<<endl;
	f<<"param d: ";
	for(int j=1;j<=nb_r;j++){
		f<<j<<" ";
	}
	f<<":="<<endl;
	for(int i=1;i<=nb_r;i++){
		f<<i<<" ";
		for(int j=1;j<=nb_r;j++){
			f<<Mat[i-1][j-1]<<" ";
		}
		if(i==nb_r){f<<";";}
		f<<endl;
	}
	f<<"end;";
	f.close();
    return 0;
}
