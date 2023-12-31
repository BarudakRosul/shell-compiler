#!/bin/bash
#
# Author: fatimazq (Fatimah Azzahra)
# GitHub: https://github.com/fatimazq
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
]   �������� �BF=�j�g�z��"�gV�>�5I��k�Z$b~�����؊��$�䡉w|h��P�ރ}9V�WC3�ϋ�֮h�N�E�8�2T/D���F=��[7رm!٘����-f*�z;�p��Ǖ�/a��8�b�Ԉ��0^g&ВN$��F���l~?e�oJd�&�2�7����Yފ�6CJ
�&�i�C��Ot���꺼L��dF���D>6fr�6@J��m�k��WGy�{��+k�`R]�h��d�5G�D�4R�g��VM��Vt94"u_8��J��Ρw��*+�Lo�]�(�\�zG�!C�%m�am	p����S�r(�EOR�*�FQ�������yn~Z����Toˣq�,ﰧg�@���h��u7/ҴF�_8�7���ύ�]XĂ�r=�YM�����VٷHBV�(A9q]�Sk��gK�eS�M�^6K���c[��vlc��ݞ�8ut��~�A����	��Tt�u�.�֬�� ���/[�8��{tS��'[g���b�	6��8N4G�u��jV���	[a�dY�M��j�Cm��~�-_E}!�$g���P,AC��K,u��FЕ��ǃ���r$Twη�\*����R�^j���oBmTg���=�ٜ���5��>~������g�[�-�[j`��8
)��%�A�=�5}EMLs���1��d6�4� �+�4_��-OV8}�=���y��Z1kR��L'k��.��;:2�GV��k�g�=8yF��_�+4���n�[�6��Ȩ�!��pw�](|ًP�]=E,�g��%��(*T����#�_� ��Ɛ��t��"��?ˁ��zx#�r�kԊA%I�7�j�K����SIU�D�DM�=�ߧ���)�܂��\������� �H�O;y�}��8��Rΐ|�c� �pa�!^D�1��0Q�0 N��yX������xl5Kj��P.G9*��)X�06�F&C"�WI;F��l^2L�K���R�;w�V��x �TD�� �ދ�ȸʣֳWX_ /��
;rA/�#̃1AeR�bk#!��j����Y����'R�߂��IDv�S�X8�-����&����P�eAͨ\nzG��# :��ipU�Xڥ/@Fk�C6��x�G�\���X'�����թ���\��oD����$̢�:үޣ����;^�*V]C���
˳��lA�$ƿ#�A��;u�܄�l�z�q�t>��>�Ƶ�?��'� S9�2�Z��r~ &� ����.�ΰa.ߦ�+�ǟ���:�(D&r/7u>k������P*4W}��^�&�pE�x�����A�Y����iFCf�С���K�}F�sN��jQH�"+��C�
�@>R$���|�{����jV@f�1��<<�Hhs:G�V*sr����[?a0�S����`�E�(�'Ʈ�aZ	��yb���^&@U���<�V�F��7����2lF��s?�G" ޑ��rh�/Q	�s��5A坪����0bW��؃O���ȵ���s{���e�G������ͫm?�h�{�'��<�0�H3ݮ�w(�ġ������
!�a.�h����O�:�fG�Q��9#�B��-�rHr����PG�) �y3��晅*-l��>Ƹ!�{Z��
���k��ujQ�77g����\7Z6��P�7b��z^�ե��q�%R��* �z��<�AIm��&��/J߽0S��]�﫰_���hi_#@h�r�ȡ �Aޱ�w��ė�N����)߳���cV���=N�����sva�?e�U��u�����鎛�:���8�R���LD1i���l��a����aoV�u�f�*ڂ�1�屴�8R��N�J���
I�=�Ġ�����*��%	qX?�ے�9e_�1=~�Gr�MԦ��4�t	�#�5X��2b���`Kݸ��cd,yDA;�x=:h�ŀ��侱��A�&�j�r����ؐ�dU�޵�����J9��a������`F�?,�%@^�H_��TlC���g-ۢ��'���)��;�Je>��Ҿ��3x�{5%�̈��6KC�:)j���[s'�,tT͉������N9urQ�^��Z��k�a���z�0T�)�
T����d��o����֙Ř��緩��b�0��Y(G�#��$�P/k�S�`�?�Dȧ��ػ�}�����8�N�pm�zraA~�f��d=�
���X���4p���]�(_����]'���.(kw:!�t�Y��˟j� ���}~D�	<�q땆xY�_m
t�4@`��Y��8�{� ޹�F(�g��φ�YA�׆XX<�gg�`8�$h)����$Sy!MDP�7��PX�+[��v��J>C zά؊���э�:��]Xl��~�.����}>���/`�Rbo~��_�����0�H��E>���e��[n�g��l��� G��F�%��O�[���l��>�}��c#��EI�*�,���EPu�m_^��� g��Os�|B�퐦�ٖ�d�����o�J�P�	�lC�U��#;C޿���YI2l]���N�!^ȯ,��p!զOA##��ʍ[�r�[=�����2[fy���t��v��.`g�y}�	�8���r~����*E����ɮx��SP;��],j�*f���1�4 ��B��ͥg�Te~��ɚ�z�r�Y1(��.��2'�v�3��a\�1x��c��'P��c�p�X��L�d�-�4|jֲ� ��@`�cw,1B��A�d���O��E>��ܞ	(&B��I�f<x0��I��l0������M�Ƃ�왎�;� ���������3c�(�1p Uߗ���O����:.�^���֖�YAGp���n�+.V���nG���I^�[S�7�*�L��7�3Tq��97,<8̈-4(Wœ��!;������vFL[C	q3?��T���h�"�Cb�N�F}zz�ȇ�~���C2�v���l	���4M7+�My��\짫�Mo_��sg�B���/��vc��C��|�7=���5�U�n�M�� 8�W�)��{B�����$�j��"']8l�����
ɳXZg����i2������*�� �Y��y���p'�7��]b����{���5^�����]l^�b���~H�U<P6��)�NV�L��^��B�7o�B[B�w-c��X �_ɗ�L�^B��O]�M-O�2`�qJ��;��rC��!zp�� w�Y���F1_҄��9�Ŋe�H��-y��gʵ�NGlukD2ƶ�'w6;���WC}�IR����8�rq��oP��}o�`&w7({��#���� �����G�!��b�>.�ʄs3�(�r�͎-�Mj� ��+��.͇�R��P�z������m��m�op��L�\�]��j5ez��v>Չ(�K���3��-�r,�]��h|�C�['1
� ��)���� -��X7��Y\�
=��Z(�ng��`d=�>���A��cH4��w�r:ӓ��l�_��lrBK��(�8��D�%�ĖӦ��+���,�cu0���T:;�(��p%@���ۀ��+yM�l>�1T�x+_[��5qל��6���$	ɛfp�Zx0QOM��N���ϸ���ai���^U��7r�<�ؚ��a!Ƒ�=��"���n�[PD���Q��n��bT4������I��k���!�� U=���ΌF�3ی6y����mt��~��~Y=�ut��B����|(,"�t��=��D��4ю�I����?,>�n�}��Ix䲖�nW��ڙU�������u;�M����k9�Gp�}L�E�����10�W>MI�>��z{�ms�$�jJb℅ê�yI����VG9`�v��s&mwŖ���jP�2���r��v
�ɴ\����hmFp!]r�ՙy(���W��&�p��։��#ʦK��q�Ζ�Zu���q}nG
K�{�5�d�w����ͨ��b��o����8�)&&II��%"�n�>�h��tmVY��_�����i�B�Y�@3ܛK�7�_���6�B���h���L�&�ʸ�����q}��^��r��F
ׂuP9p��,2�^�d4[c1������&��;ڮ�	(����^�\h��es��p�3�ڻ+F�	O<�3T<���r��������t��+���[�E����ĭ�6��4�~��!�7�N�gv!�⫎-�5���-��O�Z�-Q���R3ʱ�S�"�%�9�7�g�=��<�}2!¿� ���e�J�dB6ZUc��u��������?H�L������AIfGq2'<Fk��C�3��,_�nd��5�!��.�F��G�#}g�g}���H�j]�(`�Y��Ll�N��M�p%'��͌�)'��-s�i���F@��"D�ML7�yl��b{�����' �C:��Tڌ�a���V�k���ߐ�l]�8�p��v]t���k�6Ln�z��{��0���r��m�ȧ�c�1}����4&D�Y�B�lb�lqR����J���Or��-��5c����-þlP_S�nq6)dQC�������4	�J�橓̛j���	���<=
ׅ���ei���}����3=�Xq�q��5���=�+g=h�BD��0���R!Ү�`DM�W��iʉGw�%�ا&��9��:f'�v��Z339�l���[���+m ���$��~�D�~L��[Q&dN��r@v4o��W�9
n?�W�� ~Z�jwY:K��1�M�gB��Ҁ��aG�"}����c��J�q�
�0~����D�VJ��ٜ�[�,��kAh0�T�2����?&�	2�i�E�5Ҳ;?!ze�^��i6�؏�y����sT�攷g�_�;w:k1��7|ۢ����������E�޵�UT��.��	�'�BgF���:M9�mRa��%��ɿ�G�f�7Й6�Ő_�m���f�����듽�IS��E��-� k/�^}��ï��{x�&�ZW6% ���,ܶ-P�}��7�� U�b�uE��kl�r�9g�˕��Se��5����Typ�٧��h/X�D�>����:�bk7���g�� �(Ny;h������B���T%�4ef٨�8����&����dg�:��H#k���24d^�G�=��-��5t�6�S�cP�7�Û��~�y��"]/�"zg����R���-�����G1��3�R�H�.1���dd<ߕS��N�]U{׋�S.|Jyw8M�/9De�4�# �>*Iy�2� �u�����Ƞ���'����n�����1��<������7"���c���^��*Af�����%��C���s�>�l��Z�>�ט���	�U��Y�xP�]q���S��Wo�R҅Hi-j����r��b�&ނ���l<;c��TN}l�_�X��&Ň)%c8F��@���U�igke�����	W���Я�:��r�K�b\5�^�:&]Ż<�|��u��ۚ����0j�