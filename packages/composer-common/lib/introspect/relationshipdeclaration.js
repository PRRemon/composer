/*
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

'use strict';

const Property = require('./property');
const IllegalModelException = require('./illegalmodelexception');
const ModelUtil = require('../modelutil');

/**
 * Class representing a relationship between model elements
 * @extends Property
 * @see See [Property]{@link module:composer-common.Property}
 * @private
 * @class
 * @memberof module:composer-common
 */
class RelationshipDeclaration extends Property {

    /**
     * Create a Relationship.
     * @param {ClassDeclaration} parent - The owner of this property
     * @param {Object} ast - The AST created by the parser
     * @throws {InvalidModelException}
     */
    constructor(parent, ast) {
        super(parent, ast);
    }

    /**
     * Validate the property
     * @param {ClassDeclaration} classDecl the class declaration of the property
     * @throws {InvalidModelException}
     * @private
     */
    validate(classDecl) {
        super.validate(classDecl);
        // relationship cannot point to primitive types
        if(!this.getType()) {
            throw new IllegalModelException('Relationship must have a type');
        }

        let classDeclaration = null;

        // you can't have a relationship with a primitive...
        if(ModelUtil.isPrimitiveType(this.getType())) {
            throw new IllegalModelException('Relationship ' + this.getName() + ' cannot be to the primitive type ' + this.getType() );
        }
        else {
            // we first try to get the type from our own model file
            // because during validate we have not yet been added to the model manager
            if(this.getParent().getModelFile().getNamespace() === ModelUtil.getNamespace(this.getFullyQualifiedTypeName())) {
                classDeclaration = this.getParent().getModelFile().getType(this.getType());
            }
            else {
              // otherwise we have to use the modelmanager to try to load
                classDeclaration = this.getParent().getModelFile().getModelManager().getType(this.getFullyQualifiedTypeName());
            }

            if(classDeclaration === null) {
                throw new IllegalModelException('Relationship ' + this.getName() + ' points to a missing type ' + this.getFullyQualifiedTypeName());
            }

            if(classDeclaration.isRelationshipTarget() === false) {
                throw new IllegalModelException('Relationship ' + this.getName() + ' must be to an asset or participant, but is to ' + this.getFullyQualifiedTypeName());
            }
        }
    }

    /**
     * Returns a string representation of this property§
     * @return {String} the string version of the property.
     */
    toString() {
        return 'RelationshipDeclaration {name=' + this.name + ', type=' + this.getFullyQualifiedTypeName() + ', array=' + this.array + ', optional=' + this.optional +'}';
    }}

module.exports = RelationshipDeclaration;