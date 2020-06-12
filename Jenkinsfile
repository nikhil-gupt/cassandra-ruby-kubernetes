pipeline {
    agent any

    stages{
	stage('Build Docker Image'){
           steps{
               sh "sudo docker build . -t nik94gp/rubyapp:${BUILD_ID} "
            }
       }
       stage('DockerHub Push'){
           steps{
	       withCredentials([usernamePassword(credentialsId: '', passwordVariable: 'docPass', usernameVariable: 'docUser')]) {
                  sh "sudo docker login -u nik94gp -p ${docPass}"
                  sh "sudo docker push nik94gp/rubyapp:${BUILD_ID}"
            }
       
           }
            
       }    
        
        stage('changing tag'){
            steps{
	        sh "chmod +x imagetag.sh"
	        sh "./imagetag.sh ${BUILD_ID}"
                
					}
		}
	    
	     stage('Creating cassandra Cluster'){
	         steps{
		     sh "sudo kubectl create -f pv-cassandra.yml"
	             sh "sudo kubectl create -f pvc-cassandra.yml"
		     sh "sudo kubectl create -f svc-cassandra-clusterip.yml"
		     sh "sudo kubectl create -f cassandra-statefulset.yml"
			  			   
		}	
	}
        stage('Wait for cassandra Cluster to UP'){
	          steps{
		       sh "sleep 60"
			
		  }
		}
        stage('Deploying Ruby app into K8s'){
	        steps{
			sh "sudo kubectl create -f deployment-ruby.yml"
		        sh "sudo kubectl create -f svc-nodeport.yml"
			sh "sudo kubectl create -f svc-ruby-clusterIP.yml"
		        sh "sudo kubectl create -f ingress-ruby.yml"
		   
			   
		 }	
	}		
    }
}	
	
	

    

