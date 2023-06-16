
echo reading $0...

export mysqlpassword=simplePassword

# suspicious_khorana
export mysqlcontainer=suspicious_khorana
export mysqlcontainer2=f72934ad18ef

export JBOSS_HOME="/home/tom/Documents/vintrace/repos/jboss-eap-6.4.21/"
export DBBACKUP="/home/tom/Documents/vintrace/dbBackup"

alias mysqldocker='docker exec -it $mysqlcontainer2 mysql -uroot -p$mysqlpassword '
alias mysqldocker_auto_exec='docker exec -i $mysqlcontainer2 mysql -uroot -p$mysqlpassword '
alias vintraceServerStart='/home/tom/Documents/vintrace/repos/jboss-eap-6.4.21/bin/standalone.sh '
export jbossRunningXML=/home/tom/Documents/vintrace/repos/jboss-eap-6.4.21/standalone/deployments/mysqlvinx2-6_1-ds.xml

updateMySQLConfig(){
    docker cp $DBBACKUP/my.cnf $mysqlcontainer2:/etc/mysql/my.cnf
}

importDBwithNameAndFilePath(){
    export dbName=$2
    fileName=$1
    defaultPath=~/Documents/vintrace/dbBackup/
    echo calling $0 with dbName=$dbName and fileName=$fileName
    echo default path:$defaultPath

    echo clear $dbName if exists
    mysqldocker_auto_exec -e "drop database if exists "$dbName";create database "$dbName";" &&

    echo load db from $defaultPath$fileName
    mysqldocker_auto_exec $dbName < $defaultPath$fileName &&
#     mysqldocker_auto_exec $dbName -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' identified by '"$mysqlpassword"'" &&
#     mysqldocker_auto_exec $dbName -e "update systemuser set cryptedPassword=null,password='123' where username='sysadmin'"
    
    echo setting up for local use...
    enableRootAccess $dbName
    disableCarafe $dbName
    updateTemplateFolder $dbName
    
    reduceLastFixup $dbName

}


importDBwithNameAndFilePathX(){
    end=$1
    end=$((end -1))
    for i in {0..$end}
    do
        importDBwithNameAndFilePath $2 $3$i
        echo done round $i
        echo -------------------------
    done
}

enableRootAccess(){
    echo calling $0 with $1
    dbName=$1
    mysqldocker_auto_exec $dbName -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' identified by '"$mysqlpassword"'" &&
    mysqldocker_auto_exec $dbName -e "update systemuser set cryptedPassword=null,password='123' where username='sysadmin'"
}

disableCarafe(){
    echo calling $0 with $1
    dbName=$1
    mysqldocker_auto_exec $dbName -e "update systemsetting set value=false where name='USE_CARAFE_AUTH'"
}

updateTemplateFolder(){
    echo calling $0 with $1 using $VINTRACE_SERVER_HOME"/templates"
    dbName=$1
    mysqldocker_auto_exec $dbName -e "update systemsetting set value='"$VINTRACE_SERVER_HOME"/templates' where name='DEFAULT_TEMPLATE_FOLDER_PATH';"
    # mysqldocker $dbName -e "update systemsetting set value='"$path"' where name='DEFAULT_TEMPLATE_FOLDER_PATH';"
}

reduceLastFixup(){
    mysqldocker_auto_exec $1 -e "update systempolicy set lastFixup=lastFixup-10;"
}


updateJBossDbName(){
    echo new JBossDbName: $1
    export dbName=$1

    base="jdbc\:mysql\:\/\/localhost\:3306\/"
    oldJBossDbName="$base.*\?"
    newJBossDbName="$base$1\?"

    sed -i -E "s/$oldJBossDbName/$newJBossDbName/g" $jbossRunningXML

}

updateJBossDbNameAndStartServer(){
    updateJBossDbName $1
    startServer
}


startServer(){
    vintraceServerStart -Djboss.bind.address=0.0.0.0 -DVINTRACE_ENV=local --server-config=standalone.v2.xml --debug
}

dropDB(){
    db="acc,accwines,atlas,clearCost,cognac,foleyOrig1,foleyOrig2,foleyOrig3,foleyOrig4,foleyWithFix,gmw,grapevine,jcwClearCost,jon,moppa20230104,must_20221222,nelson,peju,rnr,shsdemo,tas,vintrace233c,woa"
    dbList=(`echo $db | tr ',' ' '`)
    for dbName in "${dbList[@]}"; do
        echo clear $dbName if exists
        mysqldocker_auto_exec -e "drop database if exists "$dbName";"

    done
}

searchAndKill(){
    if [ "$#" ];
    then
        export keywordToSearchAndKill=$1
        
    else
        echo "no argument supplied"
    fi
    ps -ef | grep $keywordToSearchAndKill | grep -v grep | awk '{print $2}' | xargs kill -9

}