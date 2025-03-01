"use strict";var __create=Object.create;var __defProp=Object.defineProperty;var __getOwnPropDesc=Object.getOwnPropertyDescriptor;var __getOwnPropNames=Object.getOwnPropertyNames;var __getProtoOf=Object.getPrototypeOf;var __hasOwnProp=Object.prototype.hasOwnProperty;var __copyProps=(to,from,except,desc)=>{if(from&&typeof from==="object"||typeof from==="function"){for(let key of __getOwnPropNames(from))if(!__hasOwnProp.call(to,key)&&key!==except)__defProp(to,key,{get:()=>from[key],enumerable:!(desc=__getOwnPropDesc(from,key))||desc.enumerable})}return to};var __toESM=(mod,isNodeMode,target)=>(target=mod!=null?__create(__getProtoOf(mod)):{},__copyProps(isNodeMode||!mod||!mod.__esModule?__defProp(target,"default",{value:mod,enumerable:true}):target,mod));var http=__toESM(require("http"));var metrics={players_online:0,total_resources:0};var generateMetrics=()=>{return`
# HELP players_online Número de jogadores conectados
# TYPE players_online gauge
players_online ${metrics.players_online}

# HELP total_resources Número total de recursos carregados
# TYPE total_resources gauge
total_resources ${metrics.total_resources}
    `};var server=http.createServer((req,res)=>{if(req.url==="/metrics"){res.writeHead(200,{"Content-Type":"text/plain"});res.end(generateMetrics())}else{res.writeHead(404);res.end("Not Found")}});var PORT=9100;server.listen(PORT,()=>{console.log(`Servidor de métricas rodando na porta ${PORT}`)});setInterval(()=>{metrics.players_online=GetNumPlayerIndices();metrics.total_resources=GetNumResources()},5e3);
