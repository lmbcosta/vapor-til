import Vapor
import Fluent

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    router.post("api", "acronyms") { req -> Future<Acronym> in
        return try req.content.decode(Acronym.self).flatMap({ acronym in
            acronym.save(on: req)
        })
    }
    
    router.get("api", "acronyms") { req -> Future<[Acronym]> in
        return Acronym.query(on: req).all()
    }
    
    router.get("api", "acronyms", Acronym.parameter) { req -> Future<Acronym> in
        return try req.parameters.next(Acronym.self)
    }
    
    router.get("api", "acronyms", "search") { req -> Future<[Acronym]> in
        guard let searchTerm = req.query[String.self, at: "term"] else {
            throw Abort(.badRequest)
        }
        
        return Acronym.query(on: req).group(.or, closure: { or in
            or.filter(\.long == searchTerm)
            or.filter(\.short == searchTerm)
        }).all()
    }
    
    router.get("api", "acronyms", "first") { req -> Future<Acronym> in
        return Acronym.query(on: req).first().map({ acronym in
            guard let first = acronym else { throw Abort.init(.notFound) }
            
            return first
        })
    }
    
    router.put("api", "acronyms", Acronym.parameter, use: { req -> Future<Acronym> in
        return try flatMap(req.content.decode(Acronym.self), req.parameters.next(Acronym.self), { (updatedAcronym, acronym) in
            acronym.short = updatedAcronym.short
            acronym.long = updatedAcronym.long
            return acronym.save(on: req)
        })
    })
    
    router.delete("api", "acronyms", Acronym.parameter) {req -> Future<HTTPStatus> in
        return try req.parameters.next(Acronym.self)
            .delete(on: req)
            .transform(to: HTTPStatus.noContent)
    }
    
    router.delete("api", "acronyms", "all", use: { req -> Future<HTTPStatus> in
        return Acronym.query(on: req)
            .delete(force: true)
            .transform(to: HTTPStatus.noContent)
    })
    
    router.get("api", "acronyms", "sorted") { req -> Future<[Acronym]> in
        return Acronym.query(on: req).sort(\.short, .ascending).all()
    }
}
