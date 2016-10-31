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

// g++ instance_generator_v2_gnu.cpp -o pref_gnu.exe
// ./pref_gnu.exe --seed 123132132 --sci 10 --inge 10 --hor 10 --name
//sci= nombre de scientifique
//inge = nombre d'industriels
//hor = nombre de creneaux horaires
//name = nom du fichier.dat de sortie

int seed=1234567;
int nb_i=10;
int nb_s=10;
int nb_h=10;
char* name="pref_gnu.dat"; //nom du fichier de sortie
vector<string> liste_name; //futur vecteur de prenoms
vector<int> name_chosen; //dit quel nom est present ou nom
vector<string> nom_sci;
vector<string> nom_inge;

/*Read parameters from command line*/
/*NOTE: Complete parameter list*/
void read_parameters(int argc, char *argv[]){
	int i;
	if(argc<=1) {
		cout<<"valeurs par defaut: sci=10; inge=10; hor=10"<<endl;
		nb_s=10;
		nb_i=10;
	}
	for(i=1;i<argc;i++){
		if(strcmp(argv[i], "--seed") == 0){
			seed=atoi(argv[i+1]);
			i+=1;
		}else if(strcmp(argv[i], "--sci") == 0){
			nb_s=atoi(argv[i+1]);
			i+=1;
		}else if(strcmp(argv[i], "--inge") == 0){
			nb_i=atoi(argv[i+1]);
			i+=1;
		}else if(strcmp(argv[i], "--hor") == 0){
			nb_h=atoi(argv[i+1]);
			i+=1;
		}else if(strcmp(argv[i], "--name") == 0){
			name=argv[i+1];	
			i+=1;
		}else {
			printf("\nERROR: parameter %s not recognized.\n",argv[i]);
			exit( EXIT_FAILURE );
		}
	}
}


void init(int nbs, int nbi){
	string name;
	ifstream lec("liste_prenom_meta.txt");
	for(int i=0;i<100;i++){
		lec >> name;
		liste_name.push_back(name);
		name_chosen.push_back(0);
	}
	for(int i=0;i<nbs;i++){nom_sci.push_back("");}
	for(int i=0;i<nbi;i++){nom_inge.push_back("");}
}

void choix_prenoms(int nbs, int nbi){
	int ntot=nbs+nbi;	
	int r=0;
	for(int i=0;i<ntot;i++){
		r=rand()%(100);
		if(i<nbs){nom_sci[i]=liste_name[r];}
		else{nom_inge[i-nbs]=liste_name[r];}
	}
}

int main(int argc, char* argv[])
{
	read_parameters(argc, argv);
	int r=0;
	srand(seed);
	init(nb_s, nb_i);
	choix_prenoms(nb_s,nb_i);
//***********************
	fstream f(name,ios::out);
	f<<"data;"<<endl;
	f<<"param nbi:= "<<nb_i<<";"<<endl;
	f<<"param nbr:= "<<nb_s<<";"<<endl;
	f<<"param nbh:= "<<nb_h<<";"<<endl;
	f<<endl;
	f<<"param p: ";
	for(int j=1;j<=nb_s;j++){
		f<<j<<" ";
	}
	f<<":="<<endl;
	for(int i=1;i<=nb_i;i++){
		f<<i<<" ";
		for(int j=1;j<=nb_s;j++){
			r=rand()%(100);
			f<<r<<" ";
		}
		if(i==nb_i){f<<";";}
		f<<endl;
	}
	f<<endl;
//
	f<<"param p_prim: ";
	for(int j=1;j<=nb_i;j++){
		f<<j<<" ";
	}
	f<<":="<<endl;
	for(int i=1;i<=nb_s;i++){
		f<<i<<" ";
		for(int j=1;j<=nb_i;j++){
			r=rand()%(100);
			f<<r<<" ";
		}
		if(i==nb_s){f<<";";}
		f<<endl;
	}
//
	f<<"end;";
	f.close();
	cout<<"fini"<<endl;
    return 0;
}
