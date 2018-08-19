#include <cstdint>
#include <iostream>
#include <vector>

#include <bsoncxx/builder/stream/document.hpp>
#include <bsoncxx/json.hpp>
#include <mongocxx/client.hpp>
#include <mongocxx/instance.hpp>
#include <mongocxx/stdx.hpp>
#include <mongocxx/uri.hpp>

using bsoncxx::builder::stream::close_array;
using bsoncxx::builder::stream::close_document;
using bsoncxx::builder::stream::document;
using bsoncxx::builder::stream::finalize;
using bsoncxx::builder::stream::open_array;
using bsoncxx::builder::stream::open_document;

using namespace std;

mongocxx::instance inst{}; // This should be done only once.
mongocxx::uri uri("mongodb://mongodb:27017");
mongocxx::client client(uri);

mongocxx::database db = client["mongodb-c++"];
mongocxx::collection collection = db["teams"];

void create()
{
    auto builder = bsoncxx::builder::stream::document{};
    bsoncxx::document::value doc_value = builder
                                         << "name"
                                         << "Flamengo"
                                         << "honors" << bsoncxx::builder::stream::open_array
                                         << "Copa Libertadores"
                                         << "Campeonato Brasileiro Série A"
                                         << close_array
                                         << "info" << bsoncxx::builder::stream::open_document
                                         << "year" << 1895
                                         << bsoncxx::builder::stream::close_document
                                         << bsoncxx::builder::stream::finalize;

    bsoncxx::stdx::optional<mongocxx::result::insert_one> result = collection.insert_one(doc_value.view());
}
void read()
{
    bsoncxx::document::view_or_value filter = document{} << "name"
                                                         << "Flamengo"
                                                         << finalize;
    bsoncxx::stdx::optional<bsoncxx::document::value> maybe_result = collection.find_one(filter);
    if (maybe_result)
    {
        std::cout << bsoncxx::to_json(*maybe_result) << "\n\n";
    }
}
void update()
{
    collection.update_one(document{} << "name"
                                     << "Flamengo" << finalize,
                          document{} << "$set" << open_document << "i" << 110 << close_document << finalize);
}
void remove()
{
    collection.delete_one(document{} << "name"
                                     << "Flamengo" << finalize);
}

// Source: http://mongodb.github.io/mongo-cxx-driver/mongocxx-v3/tutorial/

int main(int, char **)
{
    create();
    read();

    update();
    read();

    remove();
    read();
}
