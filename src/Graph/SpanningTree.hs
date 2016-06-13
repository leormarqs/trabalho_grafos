module Graph.SpanningTree where

import Data.List
import Graph.Graph


spanningTree :: Graph -> Graph
spanningTree g = spanning close open es (Graph n [])
  where
    close       = [n']
    n@(n':open) = getNodes g
    es          = getEdges g



spanning :: [NodeId] -> [NodeId] -> [Edge] -> Graph -> Graph
spanning    _        []       _   graph = graph
spanning close open edges graph = do

  let e = sort $ inOutEdges close open edges

      (s:t:_) = nodesOf (head e)

      (i,o)   = if elem s close
                then (t:close , delete t open)
                else (s:close , delete s open)

  if null e
    then error "Disconnected Graph"
    else spanning i o edges (insertEdge (head e) graph)
         
  
inOutEdges :: [NodeId] -> [NodeId] -> [Edge] -> [Edge]
inOutEdges    []          _       _   = []
inOutEdges close@(n:ns)  open   edges = do
  let es     = incidentEdges n (Graph close edges)
      es'    = filter (\x -> isInOut x close open) es
        
      isInOut :: Edge -> [NodeId] -> [NodeId] -> Bool
      isInOut (Edge _ (s:t:_) _) close open =
        ((elem s close) && (elem t open)) ||
        ((elem s open) && (elem t close))
      
  es' ++ inOutEdges ns open edges
