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
int size_map=100; //taille de la carte où sont placées les salles
vector<int> room_abs; //absisse des salles
vector<int> room_ord; //ordonnee des salles
int** Mat=new int*[nb_r+1];

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
	for(int i=0;i<nb_r-1;i++){
		for(int j=i+1;j<nb_r-1;j++){
			Mat[i][j]=sqrt((room_ord[j]-room_ord[i])*(room_ord[j]-room_ord[i])+(room_abs[j]-room_abs[i])*(room_abs[j]-room_abs[i]));
			Mat[j][i]=Mat[i][j];
		}
	}
}

int main(int argc, char* argv[])
{
	srand(501);
	nb_r=nb_r+1;
	init(nb_r);
	choice_coord(nb_r);
	update_mat(nb_r);
	fstream f("room.txt",ios::out);
	f<<"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"<<endl;
	f<<"<room_list>"<<endl;
	f<<"	<room_number>"<<nb_r<<"</room_number>"<<endl;
	for(int i=0;i<nb_r;i++){
		f<<"	<room>"<<endl;
		f<<"		<id>"<<i+1<<"</id>"<<endl;
		f<<"		<distances_list>"<<endl;
		for(int j=0;j<nb_r;j++){
			f<<"			<room>"<<endl;
			f<<"				<id>"<<j+1<<"</id>"<<endl;
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
