/*
 * generated by Xtext 2.20.0
 */
package org.qdt.quingo.generator;

import com.google.inject.Inject;
import com.google.inject.Injector;
import com.google.inject.Provider;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.xtext.generator.GeneratorContext;
import org.eclipse.xtext.generator.GeneratorDelegate;
import org.eclipse.xtext.generator.JavaIoFileSystemAccess;
import org.eclipse.xtext.util.CancelIndicator;
import org.eclipse.xtext.validation.CheckMode;
import org.eclipse.xtext.validation.IResourceValidator;
import org.eclipse.xtext.validation.Issue;
import org.qdt.quingo.QuingoStandaloneSetup;
import org.qdt.quingo.quingo.AbstractElement;
import org.qdt.quingo.quingo.FunDeclaration;
import org.qdt.quingo.quingo.Program;

public class Main {
	public static Boolean debugMode = false;

	static void printUsage() {
		System.out.println("Usage: java -jar quingo.jar <Quingo_files> <configuration_file> [options]");
		System.out.println("Options: ");
		System.out.println("\t-o --output <STRING>     Set the output file name.");
		System.out.println("\t-s --shared-addr <INT>   Set the starting address of the return values.");
		System.out.println("\t-t --static-addr <INT>   Set the starting address for storing variables.");
		System.out.println("\t-d --dynamic-addr <INT>  Set the starting address for allocating arrays.");
		System.out.println("\t-u --max-unroll <INT>    Set the maximum number of loop unrolling.");
		System.out.println("\t-h --help                Print this help message.");
		System.out.println("\t-v --version             Print version information.");
	}

	public static void main(String[] args) {
		if (args.length == 0) {
			printUsage();
			System.exit(-1);
			return;
		}
		
//		debugMode = false;

		List<String> custom_args = Arrays.asList("D:\\GitHub\\git_pcl\\compiler_xtext\\quingo.source\\src\\debug_use\\kernel.qu",
			"D:\\GitHub\\git_pcl\\compiler_xtext\\quingo.source\\src\\debug_use\\config.qfg",
			"D:\\GitHub\\git_pcl\\compiler_xtext\\quingo.source\\src\\debug_use\\standard_operations.qu",
			"-o", "D:\\GitHub\\git_pcl\\compiler_xtext\\quingo.source\\src\\debug_use\\build\\debug.eqasm",
			"-s", "0",
			"-t", "65536",
			"-d", "131072",
			"-u", "100");

		List<String> mainFileList = Arrays.asList("2d_array.qu");
//		List<String> mainFileList = Arrays.asList("add.qu", "bell.qu", "qft_kernel.qu", "qrng_kernel.qu", "rb_kernel.qu", "switch_toInt.qu");

		String dirDebugUse = "D:\\GitHub\\git_pcl\\compiler_xtext\\quingo.source\\src\\debug_use\\";

//		ArrayList<String> trueArgs = new ArrayList<String>();


		Injector injector = new QuingoStandaloneSetup().createInjectorAndDoEMFRegistration();
		Main main = injector.getInstance(Main.class);
		int ret = 0;
		if (debugMode) {
			for (String kernel_fn : mainFileList) {
				String filename = dirDebugUse + kernel_fn;
				custom_args.set(0, filename);
				System.out.println("Testing the file: " + filename);
				ret = main.runGenerator(custom_args.toArray(new String[0]));
			}

		} else {

			ret = main.runGenerator(args);
		}

		if (ret != 0) {
			System.exit(ret);
		}
	}

	@Inject
	private Provider<ResourceSet> resourceSetProvider;

	@Inject
	private IResourceValidator validator;

	@Inject
	private GeneratorDelegate generator;

	@Inject
	private JavaIoFileSystemAccess fileAccess;

	protected int runGenerator(String[] string) {
		ResourceSet set = resourceSetProvider.get();
		List<Resource> all_resources = new ArrayList<Resource>();
		String mainf = "";
		Resource mainRes = null;

		for (int i = 0; i < string.length; i++) {
			switch (string[i]) {
			case "-h":
			case "-H":
			case "--help":
				printUsage();
				return 0;
			case "-v":
			case "-V":
			case "--version":
				System.out.println("Quingo compiler v0.2.0.2");
				return 0;
			case "-o":
			case "-O":
			case "--ouput":
				if (++i >= string.length) {
					System.err.println("ERROR: -o or --output should be followed with a folder name!");
					return -5;
				}
				Configuration.outputFile = string[i];
				break;
			case "-s":
			case "-S":
			case "--shared-addr":
				if (++i >= string.length) {
					System.err.println("ERROR: -s or --shared-addr should be followed with an integer!");
					return -5;
				}
				try {
					Configuration.sharedAddr = Integer.parseInt(string[i]);
				}
				catch (Exception e) {
					e.printStackTrace();
					return -5;
				}
				break;
			case "-t":
			case "-T":
			case "--static-addr":
				if (++i >= string.length) {
					System.err.println("ERROR: -t or --static-addr should be followed with an integer!");
					return -5;
				}
				try {
					Configuration.staticAddr = Integer.parseInt(string[i]);
				}
				catch (Exception e) {
					e.printStackTrace();
					return -5;
				}
				break;
			case "-d":
			case "-D":
			case "--dynamic-addr":
				if (++i >= string.length) {
					System.err.println("ERROR: -d or --dynamic-addr should be followed with an integer!");
					return -5;
				}
				try {
					Configuration.dynamicAddr = Integer.parseInt(string[i]);
				}
				catch (Exception e) {
					e.printStackTrace();
					return -5;
				}
				break;
			case "-u":
			case "-U":
			case "--max-unroll":
				if (++i >= string.length) {
					System.err.println("ERROR: -u or --max-unroll should be followed with an integer!");
					return -5;
				}
				try {
					Configuration.maxUnrolling = Integer.parseInt(string[i]);
				}
				catch (Exception e) {
					e.printStackTrace();
					return -5;
				}
				break;
			default:
				if (string[i].charAt(0) == '-') {
					System.err.println("ERROR: unrecognized option!");
					return -5;
				}
				if (!string[i].endsWith(".qu") && !string[i].endsWith(".qfg")) {
					System.err.println("ERROR: unrecognized file format!");
					return -5;
				}
				if (mainRes == null) {
					mainf = string[i];
					mainRes = set.getResource(URI.createFileURI(mainf), true);

			        all_resources.add(mainRes);
				} else if (string[i].compareTo(mainf) != 0) {
			        Resource resource = set.getResource(URI.createFileURI(string[i]), true);
			        all_resources.add(resource);
		    	}
			}
		}

		/*for (int i=0; i<all_resources.size(); ++i) {
			Program prog = (Program)all_resources.get(i).getContents().get(0);
			if (prog != null) {
				for (AbstractElement ele : prog.getElements()) {
					if (ele instanceof Include) {
						String fileName = ((Include)ele).getFile();
				        Resource resource = set.getResource(URI.createFileURI(fileName), true);
				        all_resources.add(resource);
					}
				}
			}
	    }*/
	    // Validate the resource
	    for (Resource r: all_resources) {
	        List<Issue> list = validator.validate(r, CheckMode.ALL, CancelIndicator.NullImpl);
	        if (!list.isEmpty()) {
	            for (Issue issue : list) {
	                System.err.println(issue);
	            }
	            return -1;
	        }
	    }

		Program prog = (Program)mainRes.getContents().get(0);
		if (prog == null) {
			System.err.println("ERROR: Not found main operation!");
			return -1;
		}
		Boolean found = false;
		for (AbstractElement ele : prog.getElements()) {
			if (ele != null) {
				FunDeclaration fun = (FunDeclaration) ele.getFun();
				if (fun != null && fun.getName().equals("main")) {
					found = true;
				}
			}
		}
		if (!found) {
			return -3;
		}

		// Set output folder
		if (Configuration.outputFile.equals("")) {
			fileAccess.setOutputPath(".");
		}
		else {
			File file = new File(Configuration.outputFile);
			String absolutePath = file.getAbsolutePath();
			int index = absolutePath.lastIndexOf(File.separator);
			String folder = absolutePath.substring(0, index);
			Configuration.outputFile = absolutePath.substring(index + 1);
			fileAccess.setOutputPath(folder);
		}

		// Configure and start the generator
		GeneratorContext context = new GeneratorContext();
		context.setCancelIndicator(CancelIndicator.NullImpl);
		try {
			generator.doGenerate(all_resources.get(0), fileAccess, context);
		}
		catch (Exception e) {
			e.printStackTrace();
			return -4;
		}

		System.out.println("Code generation finished.");
		return Configuration.exitCode;
	}
}

