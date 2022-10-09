/*
    RepositoryCommitTicketMapping.h
    Generated with 'sql2code' 0.0.1
    https://github.com/red-elf/SQL-to-Code
*/

#include "string"

class RepositoryCommitTicketMapping {

private:
    std::string id;
    std::string repositoryId;
    std::string ticketId;
    std::string commitHash;
    int created;
    int modified;
    bool deleted;

public:
    std::string getId();
    void setId(std::string value);
    std::string getRepositoryId();
    void setRepositoryId(std::string value);
    std::string getTicketId();
    void setTicketId(std::string value);
    std::string getCommitHash();
    void setCommitHash(std::string value);
    int getCreated();
    void setCreated(int value);
    int getModified();
    void setModified(int value);
    bool isDeleted();
    void setDeleted(bool value);
};