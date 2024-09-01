import Vapor
import Fluent

struct CategoriesController: RouteCollection {
	func boot(routes: RoutesBuilder) throws {
		let categoriesRoute = routes.grouped("api", "categories")
		categoriesRoute.post(use: createHandler)
		categoriesRoute.get(use: getAllHandler)
		categoriesRoute.get(":categoryID", use: getHandler)
		categoriesRoute.delete(":categoryID", use: deleteHandler)
		categoriesRoute.get(":categoryID", "acronyms", use: getAcronymsHandler)
		categoriesRoute.get("first", use: getFirstHandler)
		categoriesRoute.get("sorted", use: sortedHandler)
		categoriesRoute.get("search", use: searchHandler)
		categoriesRoute.put(":categoryID", use: updateHandler)
		categoriesRoute.post(":categoryID", "acronyms", ":acronymID", use: addAcronymsHandler)
		categoriesRoute.delete(":categoryID", "acronyms", ":acronymID", use: removeCategoriesHandler)
	}
	
	@Sendable
	func createHandler(_ req: Request) throws -> EventLoopFuture<Category> {
		let category = try req.content.decode(Category.self)
		return category
			.save(on: req.db)
			.map { category }
	}

	@Sendable
	func getAllHandler(_ req: Request) -> EventLoopFuture<[Category]> {
		Category
			.query(on: req.db)
			.all()
	}

	@Sendable
	func getHandler(_ req: Request)	-> EventLoopFuture<Category> {
		Category
			.find(req.parameters.get("categoryID"), on: req.db)
			.unwrap(or: Abort(.notFound))
	}
	
	@Sendable
	func deleteHandler(_ req: Request) -> EventLoopFuture<HTTPStatus> {
		Category
			.find(req.parameters.get("categoryID"), on: req.db)
			.unwrap(or: Abort(.notFound))
			.flatMap { category in
				category
					.delete(on: req.db)
					.transform(to: .noContent)
			}
	}
	
	@Sendable
	func getFirstHandler(_ req: Request) -> EventLoopFuture<Category> {
		Category
			.query(on: req.db)
			.first()
			.unwrap(or: Abort(.notFound))
	}
	
	@Sendable
	func sortedHandler(_ req: Request) -> EventLoopFuture<[Category]> {
		Category
			.query(on: req.db)
			.sort(\.$name, .ascending)
			.all()
	}
	
	@Sendable
	func getAcronymsHandler(_ req: Request) -> EventLoopFuture<[Acronym]> {
		Category
			.find(req.parameters.get("categoryID"), on: req.db)
			.unwrap(or: Abort(.notFound))
			.flatMap { category in
				category.$acronyms.get(on: req.db)
			}
	}
	
	@Sendable
	func searchHandler(_ req: Request) throws -> EventLoopFuture<[Category]> {
		guard let searchTerm = req.query[String.self, at: "term"] else {
			throw Abort(.badRequest)
		}
		return Category
			.query(on: req.db)
			.filter(\.$name == searchTerm)
			.all()
	}
	
	@Sendable
	func updateHandler(_ req: Request) throws -> EventLoopFuture<Category> {
		let updateData = try req.content.decode(Category.self)
		return Category
			.find(req.parameters.get("categoryID"), on: req.db)
			.unwrap(or: Abort(.notFound))
			.flatMap { category in
				category.name = updateData.name
				return category.save(on: req.db)
					.map { category }
			}
	}
	
	@Sendable
	func addAcronymsHandler(_ req: Request) -> EventLoopFuture<HTTPStatus> {
		let categoryQuery = Category
			.find(req.parameters.get("categoryID"), on: req.db)
			.unwrap(or: Abort(.notFound))
		let acronymQuery = Acronym
			.find(req.parameters.get("acronymID"), on: req.db)
			.unwrap(or: Abort(.notFound))
		return categoryQuery
			.and(acronymQuery)
			.flatMap { category, acronym in
				category.$acronyms
					.attach(acronym, on: req.db)
					.transform(to: .created)
			}
	}
	
	@Sendable
	func removeCategoriesHandler(_ req: Request) -> EventLoopFuture<HTTPStatus> {
		let categoryQuery = Category
			.find(req.parameters.get("categoryID"), on: req.db)
			.unwrap(or: Abort(.notFound))
		let acronymQuery = Acronym
			.find(req.parameters.get("acronymID"), on: req.db)
			.unwrap(or: Abort(.notFound))
		return categoryQuery
			.and(acronymQuery)
			.flatMap { category, acronym in
				category
					.$acronyms
					.detach(acronym, on: req.db)
					.transform(to: .noContent)
			}
	}
}
