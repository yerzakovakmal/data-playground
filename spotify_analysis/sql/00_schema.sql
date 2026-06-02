CREATE TABLE tracks (
    track_id VARCHAR(50) PRIMARY KEY,                                                                                           
    artists TEXT,                                                                                                               
    album_name TEXT,                                                                                                            
    track_name TEXT,                                                                                                            
    popularity SMALLINT,                                                                                                        
    duration_ms INTEGER,                                                                                                        
    explicit BOOLEAN,                                                                                                           
    danceability DOUBLE PRECISION,                                                                                              
    energy DOUBLE PRECISION,                                                                                                    
    key SMALLINT,                                                                                                               
    loudness DOUBLE PRECISION,                                                                                                  
    mode SMALLINT,                                                                                                              
    speechiness DOUBLE PRECISION,                                                                                               
    acousticness DOUBLE PRECISION,                                                                                              
    instrumentalness DOUBLE PRECISION,                                                                                          
    liveness DOUBLE PRECISION,                                                                                                  
    valence DOUBLE PRECISION,                                                                                                   
    tempo DOUBLE PRECISION,                                                                                                     
    time_signature SMALLINT,                                                                                                    
    duration_min DOUBLE PRECISION,                                                                                              
    is_live BOOLEAN,                                                                                                            
    is_instrumental BOOLEAN,                                                                                                    
    is_spoken_word BOOLEAN,                                                                                                     
    key_name VARCHAR(5),                                                                                                        
    mode_name VARCHAR(10)
);

CREATE TABLE track_genres (                                                                                                     
    track_id VARCHAR(50) REFERENCES tracks(track_id),                                                                           
    genre VARCHAR(100),                                                                                                         
    PRIMARY KEY (track_id, genre)                                                                                               
);