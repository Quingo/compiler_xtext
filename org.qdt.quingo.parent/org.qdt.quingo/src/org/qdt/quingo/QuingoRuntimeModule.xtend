/*
 * generated by Xtext 2.20.0
 */
package org.qdt.quingo
import org.eclipse.xtext.generator.IOutputConfigurationProvider
import org.qdt.quingo.generator.QuingoOutputConfigurationProvider
import org.eclipse.xtext.resource.XtextResourceSet
import org.qdt.quingo.resource.QuingoResourceSet
import org.eclipse.xtext.generator.IContextualOutputConfigurationProvider
import org.eclipse.xtext.generator.IContextualOutputConfigurationProvider2

/**
 * Use this class to register components to be used at runtime / without the Equinox extension registry.
 */
class QuingoRuntimeModule extends AbstractQuingoRuntimeModule {
	def Class<? extends IOutputConfigurationProvider> bindIOutputConfigurationProvider() {
		return QuingoOutputConfigurationProvider
	}
	def Class<? extends IContextualOutputConfigurationProvider> bindIContextualOutputConfigurationProvider() {
		return QuingoOutputConfigurationProvider
	}
	def Class<? extends IContextualOutputConfigurationProvider2> bindIContextualOutputConfigurationProvider2() {
		return QuingoOutputConfigurationProvider
	}
	override Class<? extends XtextResourceSet> bindXtextResourceSet() {
		return QuingoResourceSet;
	}
}
