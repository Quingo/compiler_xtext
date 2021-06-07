package org.qdt.quingo.resource

import org.eclipse.xtext.resource.SynchronizedXtextResourceSet
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.common.util.URI
import org.qdt.quingo.quingo.Program
import org.qdt.quingo.quingo.AbstractElement
import org.qdt.quingo.quingo.Include
import java.io.File

class QuingoResourceSet extends SynchronizedXtextResourceSet {
	override Resource getResource(URI uri, boolean loadOnDemand) {
		synchronized (lock) {
			var resource = super.getResource(uri, loadOnDemand);
			var prog = resource?.contents?.head
			if (prog instanceof Program) {
				for (AbstractElement ele : prog?.getElements) {
					if (ele instanceof Include) {
						var String fileName = ele.getFile;
						var fileUri = uri.trimSegments(1).appendSegments(URI.createFileURI(fileName).segments)
						var file = new File(fileUri.toPlatformString(true))
						if (file?.exists) {
					        resource.resourceSet.getResource(fileUri, true);
						}
					}
				}
			}
			return resource
		}
	}
}