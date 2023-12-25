#!/bin/bash
#
# Author: Achixz (Citra Bella Rahayu)
# GitHub: https://github.com/Achixz
#
# shell-compiler: compressor for Shell Unix executables.
# Use this only for binaries that you do not use frequently.
#
# I try invoking the compressed executable with the original name
# (for programs looking at their name).  We also try to retain the original
# file permissions on the compressed file.  For safety reasons, bzsh will
# not create setuid or setgid shell scripts.
#
# WARNING: the first line of this file must be either : or #!/bin/bash
# The : is required for some old versions of csh.
# On Ultrix, /bin/bash is too buggy, change the first line to: #!/bin/bash5
#
skip=77
set -e

tab='	'
nl='
'
IFS=" $tab$nl"

# Make sure important variables exist if not already defined
# $USER is defined by login(1) which is not always executed (e.g. containers)
# POSIX: https://pubs.opengroup.org/onlinepubs/009695299/utilities/id.html
USER=${USER:-$(id -u -n)}
# $HOME is defined at the time of login, but it could be unset. If it is unset,
# a tilde by itself (~) will not be expanded to the current user's home directory.
# POSIX: https://pubs.opengroup.org/onlinepubs/009696899/basedefs/xbd_chap08.html#tag_08_03
HOME="${HOME:-$(getent passwd $USER 2>/dev/null | cut -d: -f6)}"
# macOS does not have getent, but this works even if $HOME is unset
HOME="${HOME:-$(eval echo ~$USER)}"
umask=`umask`
umask 77

lztmpdir=
trap 'res=$?
  test -n "$lztmpdir" && rm -fr "$lztmpdir"
  (exit $res); exit $res
' 0 1 2 3 5 10 13 15

case $TMPDIR in
  / | */tmp/) test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  */tmp) TMPDIR=$TMPDIR/; test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  *:* | *) TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
esac
if type mktemp >/dev/null 2>&1; then
  lztmpdir=`mktemp -d "${TMPDIR}lztmpXXXXXXXXX"`
else
  lztmpdir=${TMPDIR}lztmp$$; mkdir $lztmpdir
fi || { (exit 127); exit 127; }

lztmp=$lztmpdir/$0
case $0 in
-* | */*'
') mkdir -p "$lztmp" && rm -r "$lztmp";;
*/*) lztmp=$lztmpdir/`basename "$0"`;;
esac || { (exit 127); exit 127; }

case `printf 'X\n' | tail -n +1 2>/dev/null` in
X) tail_n=-n;;
*) tail_n=;;
esac
if tail $tail_n +$skip <"$0" | lzma -cd > "$lztmp"; then
  umask $umask
  chmod 700 "$lztmp"
  (sleep 5; rm -fr "$lztmpdir") 2>/dev/null &
  "$lztmp" ${1+"$@"}; res=$?
else
  printf >&2 '%s\n' "Cannot decompress ${0##*/}"
  printf >&2 '%s\n' "Report bugs to <barudakrosul22garut@gmail.com>."
  (exit 127); res=127
fi; exit $res
]   �������� �BF=�j�g�z��"�gV�>�5JΧ�"���*f�A-�˻"��Lϒ��)c_kǂ�ݻ�o�-t���
K�����8Ŭ)�'Ds{.����U=6#�ɢu���һ��%�r����{�l�����7:e1噠 2�U��O�N�(�y.zۏ�B�oɎC�~�ԓ�-����NR�$|���؎#K��(-R*o@�З{H���O�T���ʱ��Σ�,�� �[�����܍����I��ȈUc��ݚ�4W���Wi�������c�Łm��C*�&�v�o"$M�$7���pO5�=��Z�h~�z~=!C�U�d�[㒋ź2D*]�;����׃o�*c�%V�X~�9�_!r�2�O�W +ɻ�l_rⷉ���J�N��W\vg~'l�h�?��`!�4�U�Vyz�l���y1�E����S�ǔ�ږ��f{��bk�+� ���땶4,�(^�|��T�6	8��.&,D�IH}�"�O��X>��1��� ��R���D�;))�ķ&jݷ�D%�:jcSx3F�H��]��7䞮Mʺ/�B�.^}}���2�a�G(%Q�MgP�P�rD�m�������u�����O�L>�ߎ���8�w���r��ۀ��8r�+�q�Z- ��n����0G�o%؝1�h��>*+êYO7�gQo���k�K�18]Wٙ=��6}�b��t�� >W�IQ��n��,d��M$���Ţŭ�&ּb���L�4n���4=�u~�����Α�C��F]�m�q��%p(i��5֩����t��xcY�ׂ�3!.KI2ɑ��\S��e䕃d��yK���9j�/x)hi�Ӷh'�{9� �hΞ�<�y�D��\J7��;��n�=E����e�J�#ʴ7�;+)�o��!IU�����=q������oc6׏CV}�3_��t�ɴ�4�}��ǽ�W���V�Uu��f�-��?����W��M��ӅO�|XC�=1�T�tJXE8��4�r/M�� v����?��2��7��A*�Dm0)��k
����æ���4�Z�7ȫ��&�GJ�.c�[-�M[���x"�퉮�X	���8OT~@����-Cw��%8�6�_m���Og"���K�x1`��gч��Y��?����[���ZNC�ӊ�),J�z�vɏ�n�f��VA�t���'�ڹ1Q\@�~��s��R��>6" �E�6DƳ�$���3�� �!�PLq����=1�U���_t�B�����.?A��|\����+G�>���߿�[��I�kCA�(�.��|�y!��n/�Zm�e���\���4r+b�d9*ړ.R0p�J۾�L�0�Ɋ*��Iːw�)�]��%;00�`�z���&:�x�bm<��Њ"G.U��U; ��v��_Gtc���]ߐW)���lsd�NH���֦r���� ?*���ƾ�tơ�K��g�q�!�u����vk���G�� f����	ORɯ�-�y�+Ԗ�<]��ڜ�^�"^#a��PQ5��/��/���W��mԽ"֥W[lFI��Zӿ,�,��f(2�U����y����8���J�����äxɕrN���ۀ�jw9Sw��ݨ.��k(Pi��/�1h�� �l��f��������9�cˡ���3zh�v�)	X�.���$l�C)B�ǡ����6�ĲA ����t�&~Y�(����C�[��X�84Ѽ��
��I�9aD>c;�#��qb���S�oT鎾�r{����ģ��g������pY:�����j��{P�ŋr�� ��0Qs]��q&��~��r;�7���v�׷Y�5�����Z���7�+$��d��H��}�0L3�tJ�O��&�qp���4uS��j�~�Nl��$�D,�)���-�K�9b�[sJ���"��Xt_�w���Y�Wr�����ܿ�\9j�j�����F�JG.kW
�n������g�O�Ġ���k:��3�*�\Ճ~���tp�Y��U"��Sؔ�����?b�Y*O]H/J� ��)��#����K���t��h� ��j��o=�����u���y�
M�ɵ�oӗ:�;C]�����^4f�$���|R	R����Mp����H���4+XU�d��gvV�������r�����7��j88�W��LSN�腽HT����r�B��Yd����OZ@ƃ'������E������5�6�5��|8��-U"q^jL1�aY�J�aS�\q�f��n��vx�����u���qoc*f�u��=�Ҳj�:�ݨ���e�/���k.P~��b��R�\o�vi�$��N'smi�KM�[���m�hݕyz\_a1�ӘzkDH��*�{��HOv;vsX�BÆ��1ˠ6r�:�����D�[��u�(�Ю�ãq�M�TM��1��[ğM�\02�_f-e�`��f�h�è���Qdg�NV-�P���If��'!ǡ@G��~%��_�\�;ۑ�SdXb�Gv3I�d>������89�\Z�#I�bA���Q����S,\��6ZR���F�)�����b� ���q���Bv}T�?)%����`ܤ�-j�*4K������Ϛ�����%0ԥoyIԋ����|]�x����p4-K�n�D�i09r�>�M�"�9�F�����l�5	�f9<��6��T��|7�$����n[�F&��C�5.V�o$"�b^cيWdS�+�6�3���XZ�a������kx�-q�N���b���T����/����0@�y���f����*
���D�qվ��٫I��)�8�+�9���z.<`��lZ��1ؑ���}k�-BӇ�ڙp�Lu��� }?$�mC�n�1Fn���I��p/C�#[�A
5�3���O�U;mA�J�h�	�#z���T�����W /l#�e�)s���{sM�b�lP>�reW|ӗ�G-��)�sR�o�7�e�#�h�.��YQ*<� �C��4�>GCùWI#��6ך���5���
�B��8�b>w@��>�K5|�ő	C��s@jr˯N��i�}���i�����L}�~i)xwm���?�H�[ko��}Xg9J@����B�i��1��c�b>:%7}��%
��i7hE���Эk��3�s�bY�j�F�[���"��!}њ5&���r����Nئp�,ΣO#�#��N%��)�8�����k�KH{���hf�Tc:F�b�uuM]��쮝E*�<����A��]��ݼ����o�+L"]����y��8ѝ����}A����C����Sm��14����Y�M�V� �TУw�v�j�R{)
/��P�G6�ƪ`��b�ZX��c� �v�*�SzQ�����a��,]�B$N�{�1���Y��۫E8��ۆe�2Նx��M
4˲�봅��8�Y���@���0��V����ǪU�'=:-�G�UlB"{�'�R/� !q����} ������g�T��&��O#��%��Hǧ���*^�ls�s��K������ƪ9��<����7��}�p���b�����@ks���+���Q%��E�%�-�������ͣ��8������������ܮހqC�C}W�x*/�Xf����4�s���焌т��K�'ڜNN��������B���R!�sO�b��d?�ؤ�$��E�M���0I&j����ѱI2d�:���	_�(�<Sn�ڟ���eK8f�?E:	<e�&F�'��~\��"+d�b��uО�t���Zso.���y�x�W�.X9���ջ׃
�Eb3N�7G��g�������������a�]�Je��z��W�����&�X_wW�Z�����y��x�h;-�B���}n�b�Xh)g��Xg��B���w���7��3���l���U��1*�)��Et� fw�_k"٬�Msn�����dY�l�"z�<A���!a~b!�L_# Z���"b�~	�̥Y
9��đ2��Iu,R@��	�p�.�-1�������$Jv'{��]D7�%�D]���d�4(�0-�=�3,���j]͖d�IU�B4k�b��:�4:#�㧯��5=���f���R�3n����]�
�n�����[�g����<1K~�k�S5w������l�㇈S��aZ����ѱ;�H<���Tp��Ʈg��x'��jx�"���O��`�qP��IU���mZ *Z���X.Թ7�f#�%a������
�洕�Y�����Z��i�� ������==ʣ�~)��g�10p�N5x�x�v�wpsA�,�S�X�:T�$����B�� �J!k�Ә��� xh`�0��;���GO�{�Ι.�����F�!߽X��a`���C����o.�@HQ&ư7�%Hf�ʵΝI'r�#tZ�ԙ�
�aWX���&YUW��󻒀��n^3��nB����r��p=0�m ��Z�jK7��$�>��V������v���+wESvk@h����q�{c��� ��2���#�4B)�7�Jqkڽ�"eeCsK�o{�N	-���-_Xyz��d�C�\��}x�Ph�ܥ=��U�؊|�NS��ƨ��2=qOxi}ՅŹ�c&����)�G+�>W��BOf�y��[4Ѓy�v���^,,3(1�a���_1j��^�x�\|-�H��:N8~	�����m�z��g��Qq~�G<;Y��h]�
�p���|�N_�c���\��q�Wp��L���Ǩ��������4S��v]18��c,L�}%�y~���^k⥋4�о��̵*����gqN�R!~��o�%-�E���'������KY�E�e���������5��*`5[��=�Q�����32��P��[Ne�O�����4ik�F�V �s�q���� ��Z{�������4�H�Jr&`4�_�`�r�fTLX=�#f^�+x�_�+��ə�:H�Q�S��m|�l�
�A�ovy�[V��Ve8̽���;��+���ްW�V+�������M�����_�L ��d\�º��-��Ɋ����Z��(�׏ޅ�!��@.se��C�t���sL�?�Y��Pƌ�&�[�<���ü>��]�h���G�#[�R�p��h��k���э��A����@a�[S4=�p�%�֮0� �-� (U����obZ�����[�:LG�xH!��(FKr���B$�T�2BWw��1$q��9�d��j��4�^�/�k=���l����;���S͹�{�n�r{]��K\�1��Ty�*F�ƫ�ڰim6���='R�xzl��s�E\ćz5$`aI袰��P��d��Z�B#M�
�v!�$]07�j+;2��/�s4u?�\�N��tŒ@�Y8�iz�*��l"NqW��{!��	PB����_����dz�~H ��Gt�Mf�gK.�;)Q>�R�,��(�'4��������2��