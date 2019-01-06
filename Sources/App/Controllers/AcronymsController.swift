import Vapor
import Fluent

struct AcronymsController: RouteCollection {
    func boot(router: Router) throws {
        
        let acronymsRouter = router.grouped("api", "acronyms")
        
        // GET ALL
        acronymsRouter.get(use: getAllHandler)
        // GET
        acronymsRouter.get(Acronym.parameter, use: getAcronymHandler)
        // GET FIRST
        acronymsRouter.get("first", use: getFirstHandler)
        // GET SEARCH
        acronymsRouter.get("search", use: searchGetHandler)
        // GET SORTED
        acronymsRouter.get("sorted", use: sortedGetHandler)
        // POST
        acronymsRouter.post(use: createHandler)
        // PUT
        acronymsRouter.put(use: updateHandler)
        // DELETE
        acronymsRouter.delete(use: deleteHandler)
        // DELETE ALL
        acronymsRouter.delete(use: deleteAllHandler)
    }
    
    func getAllHandler(_ req: Request) throws -> Future<[Acronym]> {
        return Acronym.query(on: req).all()
    }
    
    func getAcronymHandler(_ req: Request) throws -> Future<Acronym> {
        return try req.parameters.next(Acronym.self)
    }
    
    func getFirstHandler(_ req: Request) throws -> Future<Acronym> {
        return Acronym.query(on: req).first().map({ acronym in
            guard let first = acronym else { throw Abort.init(.notFound) }
            return first
        })
    }
    
    func createHandler(_ req: Request) throws -> Future<Acronym> {
        return try req.content.decode(Acronym.self)
            .flatMap({ acronym in
                return acronym.save(on: req)
            })
    }
    
    func updateHandler(_ req: Request) throws -> Future<Acronym> {
        return try flatMap(req.content.decode(Acronym.self), req.parameters.next(Acronym.self), { (updatedAcronym, acronym) -> Future<Acronym> in
            acronym.short = updatedAcronym.short
            acronym.long = updatedAcronym.long
            return acronym.save(on: req)
        })
    }
    
    func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Acronym.self)
                             .delete(on: req)
                             .transform(to: HTTPStatus.noContent)
    }
    
    func deleteAllHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return Acronym.query(on: req)
                      .delete(force: true)
                      .transform(to: .noContent)
    }
    
    func searchGetHandler(_ req: Request) throws -> Future<[Acronym]> {
        guard let term = req.query[String.self, at: "term"] else {
            throw Abort.init(.badRequest)
        }
        
        return Acronym.query(on: req).group(.or, closure: { or in
            or.filter(\.short == term)
            or.filter(\.long == term)
        }).all()
    }
    
    func sortedGetHandler(_ req: Request) throws -> Future<[Acronym]> {
        return Acronym.query(on: req).sort(\.short, .ascending).all()
    }
}
