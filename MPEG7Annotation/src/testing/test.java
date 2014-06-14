/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package testing;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Scanner;
import javax.imageio.ImageIO;
import javax.xml.transform.TransformerException;
import org.apache.commons.lang3.StringUtils;
import org.exist.xquery.modules.mpeg7.validation.Validator;
import org.exist.xquery.modules.mpeg7.x3d.colors.ScalableColorImpl;
import org.exist.xquery.modules.mpeg7.x3d.textures.EdgeHistogramImplementation;
import org.exist.xquery.modules.mpeg7.x3d.filters.ExtrusionToIFSFilter;
import org.exist.xquery.modules.mpeg7.x3d.helpers.CommonUtils;

/**
 *
 * @author Patti Spala <pd.spala@gmail.com>
 */
public class test {

    public static void main(String[] args) throws IOException, TransformerException {
        String temp = ".848 .745 .819 .745 .841 .764 .938 .819 .99 .838 .964 .819 .96 .838 .912 .836 .908 .736 .898 .745 .908 .753 .999 .765 .999 .745 .96 .76 .938 .776 .898 .771 .947 .777 .974 .781 .898 .718 .954 .723 .974 .749 .999 .724 .96 .854 .999 .854 .96 .799 .912 .801 .976 .819 .999 .819 .999 .798 .953 .788 .944 .789 .999 .709 .947 .709 .912 .819 .905 .781 .841 .792 .855 .802 .855 .819 .855 .835 .841 .812 .841 .835 .841 .854 .841 .825 .841 .709 .841 .725 .841 .802 .812 .828 .812 .854 .783 .854 .812 .765 .812 .754 .783 .765 .783 .724 .783 .827 .812 .81 .812 .793 .783 .794 .783 .81 .812 .724 .783 .709 .812 .709 .675 .834 .675 .822 .675 .79 .675 .759 .675 .804 .675 .709 .675 .854 .999 .781 .939 .735 .905 .854 .999 .84 .812 .735 .953 .759 .905 .709 .848 .964 .84 .944 .819 .963 .973 .89 .99 .871 .938 .89 .959 .87 .912 .873 .907 .955 .897 .964 .907 .972 .959 .949 .998 .964 .998 .944 .938 .932 .897 .938 .974 .927 .946 .931 .897 .99 .974 .96 .953 .986 .998 .984 .959 .854 .998 .854 .959 .909 .912 .907 .998 .89 .975 .89 .952 .92 .998 .911 .944 .919 .946 1 .998 1 .912 .89 .904 .928 .84 .916 .855 .906 .855 .873 .855 .89 .84 .896 .84 .854 .84 .874 .84 .883 .84 .984 .84 1 .84 .906 .811 .854 .811 .881 .782 .854 .811 .954 .811 .944 .782 .943 .782 .985 .811 .899 .782 .881 .811 .915 .782 .914 .782 .898 .811 .984 .782 1 .811 1 .675 .874 .675 .887 .675 .919 .675 .95 .675 .905 .675 1 .675 .854 .998 .927 .939 .973 .904 .854 .998 .869 .811 .974 .952 .95 .904 1 .061 .4 .04 .391 .029 .349 .029 .336 .016 .297 .085 .303 .085 .354 .079 .331 .139 .112 .123 .112 .145 .072 .119 .047 .063 .055 .052 .051 .055 .048 .048 .048 .107 .079 .084 .047 .082 .033 .102 .034 .156 .075 .145 .072 .148 .114 .164 .114 .156 .114 .114 .112 .091 .272 .015 .265 .019 .213 .056 .177 .019 .177 .094 .213 .094 .177 .103 .053 .057 .135 .062 .033 .082 .053 .083 .225 .03 .222 .058 .215 .024 .234 .055 .036 .144 .047 .14 .034 .122 .034 .156 .046 .156 .034 .145 .046 .167 .046 .167 .034 .02 .135 .055 .093 .04 .091 .088 .239 .048 .04 .083 .396 .145 .034 .167 .072 .056 .213 .095 .135 .067 .092 .051 .049 .656 .914 .628 .902 .656 .921 .656 .942 .624 .941 .632 .946 .656 .937 .618 .934 .605 .914 .608 .923 .592 .923 .589 .94 .656 .946 .616 .908 .582 .91 .575 .9 .553 .896 .55 .906 .522 .916 .53 .912 .522 .91 .55 .913 .53 .905 .582 .916 .49 .981 .484 .972 .479 .981 .507 .99 .504 .972 .504 .99 .516 .972 .509 .972 .553 .857 .54 .845 .538 .858 .603 .859 .603 .841 .594 .859 .619 .896 .581 .719 .566 .729 .566 .718 .555 .917 .535 .719 .563 .922 .575 .918 .595 .946 .626 .756 .619 .722 .652 .756 .543 .943 .548 .946 .522 .946 .589 .896 .585 .902 .613 .722 .581 .731 .522 .896 .568 .907 .591 .859 .597 .839 .586 .841 .56 .847 .558 .831 .551 .838 .652 .711 .627 .717 .627 .711 .652 .732 .668 .732 .668 .744 .579 .927 .534 .734 .519 .729 .529 .729 .537 .917 .533 .922 .522 .927 .522 .933 .528 .931 .536 .928 .522 .917 .526 .922 .538 .937 .532 .939 .57 .935 .568 .914 .588 .756 .545 .756 .553 .845 .546 .837 .572 .841 .528 .842 .528 .847 .528 .858 .484 .99 .535 .726 .529 .721 .512 .756 .512 .729 .519 .756 .516 .99 .56 .858 .672 .937 .672 .946 .672 .92 .672 .929 .672 .91 .656 .91 .668 .756 .254 .155 .284 .172 .28 .155 .175 .273 .215 .306 .224 .298 .175 .264 .401 .292 .475 .301 .475 .292 .408 .306 .402 .317 .223 .317 .403 .278 .475 .275 .383 .278 .352 .281 .359 .298 .315 .292 .223 .288 .175 .247 .222 .172 .245 .168 .402 .24 .373 .24 .475 .244 .269 .292 .276 .244 .31 .244 .241 .29 .251 .244 .346 .24 .225 .244 .18 .217 .368 .182 .401 .182 .471 .188 .302 .185 .277 .189 .254 .189 .229 .189 .189 .185 .341 .182 .401 .155 .368 .155 .471 .174 .227 .155 .189 .155 .263 .168 .194 .171 .341 .155 .305 .172 .31 .155 .195 .101 .214 .012 .235 .046 .234 .003 .259 .1 .262 .032 .283 .1 .289 .016 .282 .046 .344 .1 .37 .033 .369 .008 .349 .015 .314 .1 .394 .005 .393 .1 .366 .1 .319 .036 .318 .011 .443 .036 .432 .02 .396 .033 .46 .156 .446 .097 .242 -.001 .217 -.029 .272 .003 .293 .002 .265 .012 .375 .002 .357 .002 .327 .001 .39 .001 .43 .003 .229 .1 .348 .033 .212 .046 .29 .173 .255 .154 .285 .154 .475 .301 .43 .301 .432 .286 .475 .282 .372 .29 .425 .286 .379 .308 .327 .301 .218 .297 .175 .291 .172 .274 .219 .308 .217 .173 .243 .169 .413 .245 .43 .246 .475 .25 .273 .301 .28 .25 .321 .25 .24 .299 .251 .25 .364 .246 .175 .246 .22 .25 .407 .183 .429 .184 .475 .187 .282 .191 .312 .187 .254 .191 .225 .191 .186 .187 .358 .184 .39 .154 .429 .154 .475 .173 .186 .154 .222 .154 .266 .169 .194 .172 .358 .154 .315 .173 .321 .154 .195 .096 .218 -.003 .231 .007 .232 .038 .261 .096 .266 .035 .289 .096 .288 .003 .295 .023 .362 .096 .366 .011 .39 -0 .392 .033 .327 .096 .425 .001 .389 .096 .42 .096 .33 .015 .331 .037 .435 .043 .422 .033 .435 .032 .445 .096 .461 .154 .207 .001 .25 .002 .3 .001 .275 .002 .265 .004 .398 0 .377 .001 .331 .016 .341 .001 .42 .001 .443 .005 .225 .096 .366 .033 .209 .04 .361 .745 .418 .745 .419 .724 .268 .488 .3 .486 .299 .464 .462 .751 .461 .719 .361 .485 .361 .587 .335 .596 .361 .596 .361 .724 .361 .464 .27 .466 .361 .793 .39 .832 .386 .789 .361 .776 .388 .78 .416 .762 .302 .566 .292 .55 .292 .572 .361 .536 .361 .506 .303 .536 .361 .493 .299 .493 .451 .881 .428 .851 .423 .868 .459 .855 .449 .843 .297 .506 .429 .99 .402 .932 .405 .957 .361 .609 .34 .609 .393 .957 .39 .939 .361 .566 .308 .585 .361 .834 .401 .847 .402 .839 .277 .603 .233 .61 .293 .618 .288 .558 .471 .825 .467 .763 .418 .776 .458 .932 .416 .847 .411 .841 .347 .62 .361 .616 .425 .901 .361 .626 .303 .63 .338 .633 .434 .99 .297 .63 .367 .894 .388 .921 .443 .893 .265 .543 .352 .629 .347 .633 .398 .87 .361 .936 .361 .87 .365 .872 .46 .698 .423 .677 .361 .686 .361 .42 .308 .427 .274 .441 .292 .432 .273 .407 .303 .724 .306 .748 .456 .488 .422 .464 .422 .486 .264 .75 .263 .723 .422 .587 .387 .596 .454 .468 .266 .693 .296 .678 .267 .654 .305 .837 .332 .832 .337 .789 .421 .509 .452 .494 .422 .493 .431 .577 .436 .566 .422 .536 .272 .881 .272 .832 .263 .856 .305 .776 .246 .829 .297 .99 .318 .958 .324 .932 .332 .939 .295 .851 .299 .868 .306 .847 .428 .618 .492 .603 .453 .601 .432 .564 .241 .842 .293 .99 .268 .932 .356 .843 .381 .609 .297 .901 .28 .894 .374 .62 .383 .633 .418 .63 .263 .958 .337 .921 .424 .63 .355 .894 .438 .572 .456 .572 .444 .564 .369 .629 .374 .633 .329 .958 .324 .87 .359 .661 .414 .427 .43 .432 .454 .643 .355 .4 .302 .403 .456 .44 .453 .404 .419 .403 .366 .4 .434 .635 .4 .634 .363 .661 .289 .634 .322 .634 .353 .634 .368 .634 .263 .557 .469 .845 .306 .761 .259 .772 .417 .768 .273 .496 .462 .957 .417 .837 .361 .892 .357 .872 .366 .843 .322 .847 .311 .842 .321 .839 .305 .768 .334 .781";
        String delimiter = " ";
        // getLength(temp, delimiter);     

        testValidator();
        //testColorExtraction();         
        //testColorDescriptor();
        //testIndexer(new String[]{"."});
        //testExtrusion();        
        //testURIResolver();
        //testIFSExtraction();
    }

    private static void testValidator() {
        File mp7File = new File("mpeg7.xml");
        Validator mpeg7Validator = new Validator(mp7File);
        Boolean isValid = mpeg7Validator.isValid();
    }

    private static void testColorExtraction() throws IOException {
        BufferedImage img = ImageIO.read(new File("MarineDesertCamo.jpg"));
        int imgWidth = img.getWidth();
        int imgHeight = img.getHeight();
        //System.out.println(img.getRGB(1024, 0));
        //System.out.println(Arrays.toString(getPixelData(img, 974, 197)));

        String inputX3DCoordinates = ".848 .745 .819 .745 .841 .764 .938 .819 .99 .838 .964 .819 .96 .838 .912 .836 .908 .736 .898 .745 .908 .753 .999 .765 .999 .745 .96 .76 .938 .776 .898 .771 .947 .777 .974 .781 .898 .718 .954 .723 .974 .749 .999 .724 .96 .854 .999 .854 .96 .799 .912 .801 .976 .819 .999 .819 .999 .798 .953 .788 .944 .789 .999 .709 .947 .709 .912 .819 .905 .781 .841 .792 .855 .802 .855 .819 .855 .835 .841 .812 .841 .835 .841 .854 .841 .825 .841 .709 .841 .725 .841 .802 .812 .828 .812 .854 .783 .854 .812 .765 .812 .754 .783 .765 .783 .724 .783 .827 .812 .81 .812 .793 .783 .794 .783 .81 .812 .724 .783 .709 .812 .709 .675 .834 .675 .822 .675 .79 .675 .759 .675 .804 .675 .709 .675 .854 .999 .781 .939 .735 .905 .854 .999 .84 .812 .735 .953 .759 .905 .709 .848 .964 .84 .944 .819 .963 .973 .89 .99 .871 .938 .89 .959 .87 .912 .873 .907 .955 .897 .964 .907 .972 .959 .949 .998 .964 .998 .944 .938 .932 .897 .938 .974 .927 .946 .931 .897 .99 .974 .96 .953 .986 .998 .984 .959 .854 .998 .854 .959 .909 .912 .907 .998 .89 .975 .89 .952 .92 .998 .911 .944 .919 .946 1 .998 1 .912 .89 .904 .928 .84 .916 .855 .906 .855 .873 .855 .89 .84 .896 .84 .854 .84 .874 .84 .883 .84 .984 .84 1 .84 .906 .811 .854 .811 .881 .782 .854 .811 .954 .811 .944 .782 .943 .782 .985 .811 .899 .782 .881 .811 .915 .782 .914 .782 .898 .811 .984 .782 1 .811 1 .675 .874 .675 .887 .675 .919 .675 .95 .675 .905 .675 1 .675 .854 .998 .927 .939 .973 .904 .854 .998 .869 .811 .974 .952 .95 .904 1 .061 .4 .04 .391 .029 .349 .029 .336 .016 .297 .085 .303 .085 .354 .079 .331 .139 .112 .123 .112 .145 .072 .119 .047 .063 .055 .052 .051 .055 .048 .048 .048 .107 .079 .084 .047 .082 .033 .102 .034 .156 .075 .145 .072 .148 .114 .164 .114 .156 .114 .114 .112 .091 .272 .015 .265 .019 .213 .056 .177 .019 .177 .094 .213 .094 .177 .103 .053 .057 .135 .062 .033 .082 .053 .083 .225 .03 .222 .058 .215 .024 .234 .055 .036 .144 .047 .14 .034 .122 .034 .156 .046 .156 .034 .145 .046 .167 .046 .167 .034 .02 .135 .055 .093 .04 .091 .088 .239 .048 .04 .083 .396 .145 .034 .167 .072 .056 .213 .095 .135 .067 .092 .051 .049 .656 .914 .628 .902 .656 .921 .656 .942 .624 .941 .632 .946 .656 .937 .618 .934 .605 .914 .608 .923 .592 .923 .589 .94 .656 .946 .616 .908 .582 .91 .575 .9 .553 .896 .55 .906 .522 .916 .53 .912 .522 .91 .55 .913 .53 .905 .582 .916 .49 .981 .484 .972 .479 .981 .507 .99 .504 .972 .504 .99 .516 .972 .509 .972 .553 .857 .54 .845 .538 .858 .603 .859 .603 .841 .594 .859 .619 .896 .581 .719 .566 .729 .566 .718 .555 .917 .535 .719 .563 .922 .575 .918 .595 .946 .626 .756 .619 .722 .652 .756 .543 .943 .548 .946 .522 .946 .589 .896 .585 .902 .613 .722 .581 .731 .522 .896 .568 .907 .591 .859 .597 .839 .586 .841 .56 .847 .558 .831 .551 .838 .652 .711 .627 .717 .627 .711 .652 .732 .668 .732 .668 .744 .579 .927 .534 .734 .519 .729 .529 .729 .537 .917 .533 .922 .522 .927 .522 .933 .528 .931 .536 .928 .522 .917 .526 .922 .538 .937 .532 .939 .57 .935 .568 .914 .588 .756 .545 .756 .553 .845 .546 .837 .572 .841 .528 .842 .528 .847 .528 .858 .484 .99 .535 .726 .529 .721 .512 .756 .512 .729 .519 .756 .516 .99 .56 .858 .672 .937 .672 .946 .672 .92 .672 .929 .672 .91 .656 .91 .668 .756 .254 .155 .284 .172 .28 .155 .175 .273 .215 .306 .224 .298 .175 .264 .401 .292 .475 .301 .475 .292 .408 .306 .402 .317 .223 .317 .403 .278 .475 .275 .383 .278 .352 .281 .359 .298 .315 .292 .223 .288 .175 .247 .222 .172 .245 .168 .402 .24 .373 .24 .475 .244 .269 .292 .276 .244 .31 .244 .241 .29 .251 .244 .346 .24 .225 .244 .18 .217 .368 .182 .401 .182 .471 .188 .302 .185 .277 .189 .254 .189 .229 .189 .189 .185 .341 .182 .401 .155 .368 .155 .471 .174 .227 .155 .189 .155 .263 .168 .194 .171 .341 .155 .305 .172 .31 .155 .195 .101 .214 .012 .235 .046 .234 .003 .259 .1 .262 .032 .283 .1 .289 .016 .282 .046 .344 .1 .37 .033 .369 .008 .349 .015 .314 .1 .394 .005 .393 .1 .366 .1 .319 .036 .318 .011 .443 .036 .432 .02 .396 .033 .46 .156 .446 .097 .242 -.001 .217 -.029 .272 .003 .293 .002 .265 .012 .375 .002 .357 .002 .327 .001 .39 .001 .43 .003 .229 .1 .348 .033 .212 .046 .29 .173 .255 .154 .285 .154 .475 .301 .43 .301 .432 .286 .475 .282 .372 .29 .425 .286 .379 .308 .327 .301 .218 .297 .175 .291 .172 .274 .219 .308 .217 .173 .243 .169 .413 .245 .43 .246 .475 .25 .273 .301 .28 .25 .321 .25 .24 .299 .251 .25 .364 .246 .175 .246 .22 .25 .407 .183 .429 .184 .475 .187 .282 .191 .312 .187 .254 .191 .225 .191 .186 .187 .358 .184 .39 .154 .429 .154 .475 .173 .186 .154 .222 .154 .266 .169 .194 .172 .358 .154 .315 .173 .321 .154 .195 .096 .218 -.003 .231 .007 .232 .038 .261 .096 .266 .035 .289 .096 .288 .003 .295 .023 .362 .096 .366 .011 .39 -0 .392 .033 .327 .096 .425 .001 .389 .096 .42 .096 .33 .015 .331 .037 .435 .043 .422 .033 .435 .032 .445 .096 .461 .154 .207 .001 .25 .002 .3 .001 .275 .002 .265 .004 .398 0 .377 .001 .331 .016 .341 .001 .42 .001 .443 .005 .225 .096 .366 .033 .209 .04 .361 .745 .418 .745 .419 .724 .268 .488 .3 .486 .299 .464 .462 .751 .461 .719 .361 .485 .361 .587 .335 .596 .361 .596 .361 .724 .361 .464 .27 .466 .361 .793 .39 .832 .386 .789 .361 .776 .388 .78 .416 .762 .302 .566 .292 .55 .292 .572 .361 .536 .361 .506 .303 .536 .361 .493 .299 .493 .451 .881 .428 .851 .423 .868 .459 .855 .449 .843 .297 .506 .429 .99 .402 .932 .405 .957 .361 .609 .34 .609 .393 .957 .39 .939 .361 .566 .308 .585 .361 .834 .401 .847 .402 .839 .277 .603 .233 .61 .293 .618 .288 .558 .471 .825 .467 .763 .418 .776 .458 .932 .416 .847 .411 .841 .347 .62 .361 .616 .425 .901 .361 .626 .303 .63 .338 .633 .434 .99 .297 .63 .367 .894 .388 .921 .443 .893 .265 .543 .352 .629 .347 .633 .398 .87 .361 .936 .361 .87 .365 .872 .46 .698 .423 .677 .361 .686 .361 .42 .308 .427 .274 .441 .292 .432 .273 .407 .303 .724 .306 .748 .456 .488 .422 .464 .422 .486 .264 .75 .263 .723 .422 .587 .387 .596 .454 .468 .266 .693 .296 .678 .267 .654 .305 .837 .332 .832 .337 .789 .421 .509 .452 .494 .422 .493 .431 .577 .436 .566 .422 .536 .272 .881 .272 .832 .263 .856 .305 .776 .246 .829 .297 .99 .318 .958 .324 .932 .332 .939 .295 .851 .299 .868 .306 .847 .428 .618 .492 .603 .453 .601 .432 .564 .241 .842 .293 .99 .268 .932 .356 .843 .381 .609 .297 .901 .28 .894 .374 .62 .383 .633 .418 .63 .263 .958 .337 .921 .424 .63 .355 .894 .438 .572 .456 .572 .444 .564 .369 .629 .374 .633 .329 .958 .324 .87 .359 .661 .414 .427 .43 .432 .454 .643 .355 .4 .302 .403 .456 .44 .453 .404 .419 .403 .366 .4 .434 .635 .4 .634 .363 .661 .289 .634 .322 .634 .353 .634 .368 .634 .263 .557 .469 .845 .306 .761 .259 .772 .417 .768 .273 .496 .462 .957 .417 .837 .361 .892 .357 .872 .366 .843 .322 .847 .311 .842 .321 .839 .305 .768 .334 .781";
        String[] splitInputX3DCoordinates = inputX3DCoordinates.split(" ");

        List<STCoords> stValues = new ArrayList<STCoords>();
        List<XYCoords> invXYValues = new ArrayList<XYCoords>();
        List<XYCoords> xyCoords = new ArrayList<XYCoords>();
        List<int[]> pixels = new ArrayList<int[]>();
        for (int i = 0; i < splitInputX3DCoordinates.length / 2; i++) {
            Float s = Math.abs(Float.valueOf(splitInputX3DCoordinates[2 * i]));
            Float t = Math.abs(Float.valueOf(splitInputX3DCoordinates[2 * i + 1]));
            int x = Math.round(s * imgWidth);
            int _y = Math.round(t * imgHeight);
            int y = imgHeight - _y;
            //edge correction for neighbourhood detection
            if (x >= imgWidth) {
                x = imgWidth - 1;
            }
            if (y >= imgHeight) {
                y = imgHeight - 1;
            }
            STCoords coord = new STCoords(s, t);
            stValues.add(coord);
            XYCoords _xycoord = new XYCoords(x, _y);
            invXYValues.add(_xycoord);
            XYCoords xycoord = new XYCoords(x, y);
            xyCoords.add(xycoord);

        }
        for (int i = 0; i < xyCoords.size(); i++) {
            //logger.info(i + "--> x: " + (xyCoords.get(i)).x() + " y: " + (xyCoords.get(i)).y());

            pixels.add(getPixelData(img, (xyCoords.get(i)).x(), (xyCoords.get(i)).y()));
        }
        System.out.println(xyCoords.size());

        int[] p = CommonUtils.toIntArray(pixels);

    }

    private static int[] getPixelData(BufferedImage img, int x, int y) {

        int argb = img.getRGB(x, y);

        int rgb[] = new int[]{
            (argb >> 16) & 0xff, //red
            (argb >> 8) & 0xff, //green
            (argb) & 0xff //blue
        };

        //System.out.println("rgb: " + rgb[0] + " " + rgb[1] + " " + rgb[2]);
        return rgb;
    }

    private static void testColorDescriptor() throws FileNotFoundException, IOException {
        String imageFilePath = "image2.jpg";
        BufferedImage img = ImageIO.read(new FileInputStream(imageFilePath));
        //EHD
        EdgeHistogramImplementation ehdi = new EdgeHistogramImplementation(img);
        String ehdiOut = ehdi.getStringRepresentation();
        System.out.println("EHD: " + ehdiOut);
        String[] ehdiBitsCount = ehdiOut.split(" ");
        System.out.println("numOfBits: " + ehdiBitsCount.length);
        //SCD
//        int[] pixels = {2, 4, 3};
//        ScalableColorImpl scdi = new ScalableColorImpl(pixels);
//        scdi.extract(img);
        ScalableColorImpl scdi = new ScalableColorImpl(img);
        String scdiOut = scdi.getStringRepresentation();
        System.out.println("SCD: " + scdiOut);
        String[] output = scdiOut.split(";")[3].split(" ");
        for (int i = 0; i < output.length; i++) {
            System.out.println(output[i]);
        }
        System.out.println(scdiOut.substring(scdiOut.indexOf(";") + 1, scdiOut.length()));
        String[] scdiOutBits = scdiOut.split(" ");
        System.out.println("numOfBits: " + scdiOutBits.length);

    }

    private static List getPointParts(String points, int indexSize) {
        List pointParts = new ArrayList();
        String test[] = points.split(" ");
        System.out.println(test.length);
        Scanner scannedPoints = new Scanner(points).useDelimiter(" ");
        int totalPointIndex = 3 * (indexSize + 1);
        System.out.println("totalPointIndex: 3 * (" + indexSize + " + 1) = " + totalPointIndex);
        int index = 0;
        double[] floats = new double[totalPointIndex];

        while ((scannedPoints.hasNextDouble()) && (index < floats.length)) {
            double fl = scannedPoints.nextDouble();
            floats[index] = fl;
            index++;
        }
        for (int i = 0; i < floats.length; i += 3) {
            String nextPart = Double.toString(floats[i]) + " " + Double.toString(floats[i + 1]) + " " + Double.toString(floats[i + 2]);
            pointParts.add(nextPart);
        }
        return pointParts;
    }

    private static String resolveExistUri(String basePath, String filePath) {
        int countSteps = StringUtils.countMatches(filePath, "../");
        String basePathParts[] = basePath.split("/");
        List<String> basePathPartsList = new ArrayList<String>(Arrays.asList(basePathParts));
        basePathPartsList.removeAll(Arrays.asList("", null));
        String newBasePath = "";
        int remainingParts = basePathPartsList.size() - 1 - countSteps;
        for (int i = 0; i <= remainingParts; i++) {
            newBasePath = newBasePath.concat("/").concat(basePathPartsList.get(i));
        }
        return newBasePath.concat(filePath.substring(filePath.lastIndexOf("../") + 2));
    }

    private static void testExtrusion() {
        String command[] = new String[1];
        command[0] = "Extrusion5.txt";
        try {
            ArrayList<String> resultedExtrExtractionList = new ArrayList<String>();
            ArrayList<String> resultedExtrBBoxList = new ArrayList<String>();
            StringBuilder ExtrShapeStringBuilder = new StringBuilder();
            StringBuilder ExtrBBoxStringBuilder = new StringBuilder();
            String resultedExtraction = new ExtrusionToIFSFilter(command).filterGeometry();
            String ExtrBBox = resultedExtraction.substring(0, resultedExtraction.indexOf("&"));
            String ExtrShape = resultedExtraction.substring(resultedExtraction.indexOf("&") + 1);

            resultedExtrBBoxList.add(ExtrBBox);
            resultedExtrExtractionList.add(ExtrShape);

            for (int i = 0; i < resultedExtrExtractionList.size(); i++) {
                ExtrShapeStringBuilder.append(resultedExtrExtractionList.get(i));
                ExtrShapeStringBuilder.append("#");

                ExtrBBoxStringBuilder.append(resultedExtrBBoxList.get(i));
                ExtrBBoxStringBuilder.append("#");

            }
//            System.out.println("ExtrShape:" + ExtrShape);
//
//            System.out.println("ExtrShapeStringBuilder: " + ExtrShapeStringBuilder.toString());
//            System.out.println("ExtrBBox: " + ExtrBBox);
//            System.out.println("ExtrBBoxStringBuilder:" + ExtrBBoxStringBuilder.toString());
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    private static void testURIResolver() {
        String pt = "../HelloWorld.x3d";
        String bp = "/db/3dData/x3d/X3DForWebAuthors/Chapter13-Grouping";
        System.out.println(resolveExistUri(bp, pt));
    }

    private static void testIFSExtraction() {
        String[] coordIndexArray = null;
        String coordIndex = "0 1 2 3 -1";
        String points = "-1 -1 1 1 -1 1 1 1 1 -1 1 1 1 1 -1 -1 1 -1 -1 -1 -1 1 -1 -1";
        List totalPointParts = null;
        coordIndex = coordIndex.replaceAll("\\r|\\n", " ").trim().replaceAll(" +", " ").replaceAll(",", "");
        System.out.println(coordIndex);
        points = points.replaceAll("\\r|\\n", " ").trim().replaceAll(" +", " ").replaceAll(",", "");
        System.out.println(points);
        Scanner sc = new Scanner(coordIndex).useDelimiter(" ");
        int maxCoordIndex = 0;
        while (sc.hasNextInt()) {
            int thisVal = sc.nextInt();
            if (thisVal > maxCoordIndex) {
                maxCoordIndex = thisVal;
            }
        }
        System.out.println("maxCoordIndex: " + maxCoordIndex);

        totalPointParts = new ArrayList();
        totalPointParts = getPointParts(points, maxCoordIndex);

        if (coordIndex.contains("-1")) {
            coordIndex = coordIndex.substring(0, coordIndex.lastIndexOf("-1"));
            coordIndexArray = coordIndex.split(" -1 ");
        } else {
            coordIndexArray = new String[1];
            coordIndexArray[0] = coordIndex;
        }

        System.out.println("coordIndexArray");
        System.out.println("coordIndexArray.length: " + coordIndexArray.length);
        for (int i = 0; i < coordIndexArray.length; i++) {

            System.out.println(i + ": " + coordIndexArray[i]);
        }
        System.out.println("totalPointsParts");
        for (int j = 0; j < totalPointParts.size(); j++) {

            System.out.println(j + ": " + totalPointParts.get(j));
        }
    }

    private static void getLength(String temp, String delim) {
        //System.out.println(temp.split(delim).length);
        String[] tempSplit = temp.split(delim);
        for (int i = 0; i < tempSplit.length; i++) {
            System.out.println(i + ": " + tempSplit[i]);
        }
    }

}

class STCoords {

    private final Float s;
    private final Float t;

    public STCoords(Float xin, Float yin) {
        s = xin;
        t = yin;
    }

    public Float s() {
        return s;
    }

    public Float t() {
        return t;
    }

}

class XYCoords {

    private final Integer x;
    private final Integer y;

    public XYCoords(Integer xin, Integer yin) {
        x = xin;
        y = yin;
    }

    public Integer x() {
        return x;
    }

    public Integer y() {
        return y;
    }

}
