/// Abstract base mapper for type-safe model-entity conversions
///
/// Provides a consistent contract for converting between infrastructure models
/// and domain entities following Clean Architecture principles.
///
/// [TModel] - Infrastructure/API model type
/// [TEntity] - Domain entity type
abstract class BaseMapper<TModel, TEntity> {
  /// Converts from infrastructure model to domain entity
  ///
  /// This is the primary conversion method that implementations must provide.
  /// Transforms data from the infrastructure layer to domain layer format.
  TEntity fromModelToEntity(TModel model);

  /// Converts from domain entity to infrastructure model
  ///
  /// Optional reverse conversion for cases where entities need to be
  /// sent back to external APIs. Throws UnimplementedError by default
  /// since not all mappers need bidirectional conversion.
  TModel fromEntityToModel(TEntity entity) {
    throw UnimplementedError(
      'Reverse conversion not implemented for $runtimeType',
    );
  }

  /// Converts a list of models to a list of entities
  ///
  /// Convenience method for bulk conversions using the primary mapper.
  List<TEntity> fromModelListToEntityList(List<TModel> models) {
    return models.map(fromModelToEntity).toList();
  }

  /// Converts a list of entities to a list of models
  ///
  /// Convenience method for bulk reverse conversions.
  /// Only available if reverse conversion is implemented.
  List<TModel> fromEntityListToModelList(List<TEntity> entities) {
    return entities.map(fromEntityToModel).toList();
  }

  /// Null-safe model to entity conversion
  ///
  /// Returns null if input model is null, otherwise converts normally.
  TEntity? fromModelToEntityNullable(TModel? model) {
    return model != null ? fromModelToEntity(model) : null;
  }

  /// Null-safe entity to model conversion
  ///
  /// Returns null if input entity is null, otherwise converts normally.
  TModel? fromEntityToModelNullable(TEntity? entity) {
    return entity != null ? fromEntityToModel(entity) : null;
  }
}
